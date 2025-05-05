# XPostSanitizer
Sanitize X Post (formerly Twitter Tweet)

[![Gem Version](https://badge.fury.io/rb/x_post_sanitizer.svg)](https://badge.fury.io/rb/x_post_sanitizer)
[![test](https://github.com/sue445/x_post_sanitizer/actions/workflows/test.yml/badge.svg)](https://github.com/sue445/x_post_sanitizer/actions/workflows/test.yml)

## Installation
Install the gem and add to the application's Gemfile by executing:

```bash
bundle add x_post_sanitizer
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install x_post_sanitizer
```

## Usage
Use `XPostSanitizer.sanitize_text`

e.g.

```ruby
require "json"
require "x_post_sanitizer"

# https://x.com/github/status/866677968608927744
tweet = JSON.parse(File.read("spec/support/fixtures/full_text_tweet1.json"))

tweet["full_text"]
#=> "Introducing GitHub Marketplace, a new place to browse and buy integrations using your GitHub account. https://t.co/mPTtAxnU5z https://t.co/Wz2mUql2lc"

XPostSanitizer.sanitize_text(tweet)
#=> "Introducing GitHub Marketplace, a new place to browse and buy integrations using your GitHub account. https://github.com/blog/2359-introducing-github-marketplace-and-more-tools-to-customize-your-workflow"
```

## Features
* Expand urls in `text` or `full_text` (e.g. `t.co` url -> original url)
* Remove media urls in `text` or `full_text`
* Unescape special html characters in `text` or `full_text` (e.g. `(&gt; &lt;)` -> `(> <)`)

All methods and options are followings

https://sue445.github.io/x_post_sanitizer/XPostSanitizer.html

## vs. tweet_sanitizer
This has the same features as [tweet_sanitizer](https://github.com/sue445/tweet_sanitizer) but with the following differences

* tweet_sanitizer
    * Requires https://github.com/sferik/twitter-ruby
* x_post_sanitizer
    * Requires only plain X API response. (`Hash` which parsed JSON string)
    * No requires https://github.com/sferik/twitter-ruby

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sue445/x_post_sanitizer.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
