# frozen_string_literal: true

RSpec.describe XPostSanitizer do
  describe ".sanitize_text" do
    context "Without options" do
      subject { XPostSanitizer.sanitize_text(tweet) }

      using RSpec::Parameterized::TableSyntax

      where(:fixture_name, :expected) do
        "tweet1.json"                   | "“GitHubのリポジトリをDprecatedにするスクリプト | Web Scratch” http://htn.to/RC5eJf"
        "tweet2.json"                   | "RT @SazaeSurrealism: #sazae #sazaesan"
        "tweet3.json"                   | "テスト https://google.com/ <><>"
        "tweet4.json"                   | %Q(もういっちょテスト\nhttps://twitter.com/ <><><>"'"'"'\n&quot;)
        "tweet5.json"                   | "IPv6は全然勉強が足りてなくて。\n他はともかく、ひとまずhttp://mstdn.b-shock.orgだけはIPv6リアーチャブルにしてみようかしら。"
        "tweet6.json"                   | "TeamOn for SAKURA\nhttp://www.sakura.ne.jp/function/teamon.html\n\nさくらで始めた、グループウェアのサービス。\n1ユーザー1ヶ月あたり、194円。最低5ユーザーから。\nウチで使うにはユーザー数が余るけどw、頭の片隅にでも。"
        "full_text_tweet1.json"         | "Introducing GitHub Marketplace, a new place to browse and buy integrations using your GitHub account. https://github.com/blog/2359-introducing-github-marketplace-and-more-tools-to-customize-your-workflow"
        "retweet_full_text_tweet1.json" | "【今週の一枚】皆既日食をわかりやすく解説する動画ができました。太陽と月の「見かけの大きさ」がほぼ同じという偶然が織りなす皆既日食の感動を、美しい映像と音楽で味わってください https://buff.ly/2w5HgaH #国立天文台"
      end

      with_them do
        let(:tweet) { read_tweet_fixture(fixture_name) }

        it { should eq expected }
        it { expect { subject }.not_to change { tweet["text"] } }
        it { expect { subject }.not_to change { tweet["full_text"] } }
      end
    end

    context "With options" do
      subject do
        XPostSanitizer.sanitize_text(
          tweet,
          use_retweeted_tweet: use_retweeted_tweet,
          expand_url:          expand_url,
          remove_media_url:    remove_media_url,
          unescape:            unescape,
        )
      end

      using RSpec::Parameterized::TableSyntax

      let(:tweet) { read_tweet_fixture("retweet_full_text_tweet2.json") }

      where(:use_retweeted_tweet, :expand_url, :remove_media_url, :unescape, :expected) do
        false | false | false | false | "RT @GitHubEducation: Announcing two new GitHub Classroom features: Assignment Deadlines and Class Rosters: https://t.co/bNiJnlps5e https://…"
        true  | false | false | false | "Announcing two new GitHub Classroom features: Assignment Deadlines and Class Rosters: https://t.co/bNiJnlps5e https://t.co/C02G05tUvu"
        false | true  | false | false | "RT @GitHubEducation: Announcing two new GitHub Classroom features: Assignment Deadlines and Class Rosters: https://github.com/blog/2418-github-classroom-now-supports-deadlines-and-class-rosters https://…"
        false | false | true  | false | "RT @GitHubEducation: Announcing two new GitHub Classroom features: Assignment Deadlines and Class Rosters: https://t.co/bNiJnlps5e https://…"
        false | false | false | true  | "RT @GitHubEducation: Announcing two new GitHub Classroom features: Assignment Deadlines and Class Rosters: https://t.co/bNiJnlps5e https://…"
        true  | true  | true  | true  | "Announcing two new GitHub Classroom features: Assignment Deadlines and Class Rosters: https://github.com/blog/2418-github-classroom-now-supports-deadlines-and-class-rosters"
      end

      with_them do
        it { should eq expected }
      end
    end
  end

  describe ".expand_urls_in_text" do
    subject { XPostSanitizer.expand_urls_in_text(tweet, text) }

    using RSpec::Parameterized::TableSyntax

    where(:fixture_name, :expected) do
      "tweet1.json" | "“GitHubのリポジトリをDprecatedにするスクリプト | Web Scratch” http://htn.to/RC5eJf"
    end

    with_them do
      let(:tweet) { read_tweet_fixture(fixture_name) }
      let(:text) { XPostSanitizer.tweet_full_text(tweet) }

      it { should eq expected }
      it { expect { subject }.not_to change { tweet["text"] } }
      it { expect { subject }.not_to change { tweet["full_text"] } }
    end
  end

  describe ".tweet_full_text" do
    subject { XPostSanitizer.tweet_full_text(tweet) }

    using RSpec::Parameterized::TableSyntax

    where(:fixture_name, :expected) do
      "tweet1.json"           | "“GitHubのリポジトリをDprecatedにするスクリプト | Web Scratch” https://t.co/vG7cvDAMEb"
      "full_text_tweet1.json" | "Introducing GitHub Marketplace, a new place to browse and buy integrations using your GitHub account. https://t.co/mPTtAxnU5z https://t.co/Wz2mUql2lc"
    end

    with_them do
      let(:tweet) { read_tweet_fixture(fixture_name) }

      it { should eq expected }
      it { expect { subject }.not_to change { tweet["text"] } }
      it { expect { subject }.not_to change { tweet["full_text"] } }
    end
  end

  describe ".remove_media_urls_in_tweet" do
    subject { XPostSanitizer.remove_media_urls_in_tweet(tweet, tweet["text"]) }

    using RSpec::Parameterized::TableSyntax

    where(:fixture_name, :expected) do
      "tweet2.json" | "RT @SazaeSurrealism: #sazae #sazaesan"
      "tweet1.json" | "“GitHubのリポジトリをDprecatedにするスクリプト | Web Scratch” https://t.co/vG7cvDAMEb"
    end

    with_them do
      let(:tweet) { read_tweet_fixture(fixture_name) }

      it { should eq expected }
      it { expect { subject }.not_to change { tweet["text"] } }
      it { expect { subject }.not_to change { tweet["full_text"] } }
    end
  end
end
