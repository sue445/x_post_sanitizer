# frozen_string_literal: true

require_relative "x_post_sanitizer/version"

module XPostSanitizer
  class Error < StandardError; end

  # Sanitize X Post (formerly Twitter Tweet)
  #
  # @param tweet [Hash<String, Object>] Tweet object
  # @param use_retweeted_tweet [Boolean] Use original retweeted tweet if exists
  # @param expand_url          [Boolean] Whether expand url in tweet (e.g. `t.co` url -> original url)
  # @param remove_media_url    [Boolean] Whether remove media url in tweet
  # @param unescape            [Boolean] Whether unescape in tweet (e.g. `(&gt; &lt;)` -> `(> <)`)
  #
  # @return [String] Sanitized text in tweet
  #
  # @see https://developer.x.com/en/docs/x-api/v1/data-dictionary/object-model/tweet
  def self.sanitize_text(tweet, use_retweeted_tweet: true, expand_url: true, remove_media_url: true, unescape: true)
    # Original RT status exists in retweeted_status
    tweet = tweet["retweeted_status"] if use_retweeted_tweet && tweet["retweeted_status"]

    text = tweet_full_text(tweet)
    text = expand_urls_in_text(tweet, text) if expand_url
    text = remove_media_urls_in_tweet(tweet, text) if remove_media_url
    text = CGI.unescapeHTML(text) if unescape
    text
  end

  # @param tweet [Hash<String, Object>] Tweet object
  # @param text [String]
  #
  # @return [String]
  #
  # @see https://developer.x.com/en/docs/x-api/v1/data-dictionary/object-model/tweet
  def self.expand_urls_in_text(tweet, text)
    urls = tweet.dig("entities", "urls")

    return text unless urls

    urls.reverse.each_with_object(text.dup) do |url, expanded|
      pos1 = url.dig("indices", 0)
      pos2 = url.dig("indices", 1)
      expanded[pos1, pos2-pos1] = url["expanded_url"] if url["expanded_url"] && pos1 && pos2
    end
  end

  # @param tweet [Hash<String, Object>] Tweet object
  #
  # @return [String] `full_text` attribute if exist
  #
  # @see https://developer.x.com/en/docs/x-api/v1/data-dictionary/object-model/tweet
  def self.tweet_full_text(tweet)
    tweet["full_text"] || tweet["text"]
  end

  # @param tweet [Hash<String, Object>] Tweet object
  # @param text [String]
  #
  # @return [String]
  #
  # @see https://developer.x.com/en/docs/x-api/v1/data-dictionary/object-model/tweet
  def self.remove_media_urls_in_tweet(tweet, text)
    medias = get_medias(tweet)

    return text if medias.empty?

    medias.each_with_object(text.dup) do |media, t|
      t.gsub!(media["url"], "")
      t.strip!
    end
  end

  # @param tweet [Hash<String, Object>] Tweet object
  #
  # @return [Array<Hash>]
  #
  # @see https://developer.x.com/en/docs/x-api/v1/data-dictionary/object-model/tweet
  def self.get_medias(tweet)
    extended_entities_medias = tweet.dig("extended_entities", "media")
    return extended_entities_medias if extended_entities_medias

    tweet.dig("entities", "media") || []
  end
  private_class_method :get_medias
end
