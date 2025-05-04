# frozen_string_literal: true

require_relative "x_post_sanitizer/version"

module XPostSanitizer
  class Error < StandardError; end

  # Sanitize X Post (formerly Twitter Tweet)
  #
  # @param status [Hash] Response of `GET statuses/show/:id`
  # @param use_retweeted_tweet [Boolean] Whether use original retweeted tweet if exists
  # @param expand_url          [Boolean] Whether expand url in tweet (e.g. `t.co` url -> original url)
  # @param remove_media_url    [Boolean] Whether remove media url in tweet
  # @param unescape            [Boolean] Whether unescape in tweet (e.g. `(&gt; &lt;)` -> `(> <)`)
  #
  # @return [String] Sanitized text in status
  #
  # @see https://developer.x.com/en/docs/x-api/v1/tweets/post-and-engage/api-reference/get-statuses-show-id
  def self.sanitize_text(status, use_retweeted_tweet: true, expand_url: true, remove_media_url: true, unescape: true)
    # TODO: Do after
  end

  # @param status [Hash] Response of `GET statuses/show/:id`
  # @param text [String]
  #
  # @return [String]
  #
  # @see https://developer.x.com/en/docs/x-api/v1/tweets/post-and-engage/api-reference/get-statuses-show-id
  def self.expand_urls_text(status, text)
    # TODO: Do after
  end

  # @param status [Hash] Response of `GET statuses/show/:id`
  #
  # @return [String] `full_text` attribute if exist
  #
  # @see https://developer.x.com/en/docs/x-api/v1/tweets/post-and-engage/api-reference/get-statuses-show-id
  def self.status_full_text(status)
    status["full_text"] || status["text"]
  end

  # @param status [Hash] Response of `GET statuses/show/:id`
  # @param text [String]
  #
  # @return [String]
  #
  # @see https://developer.x.com/en/docs/x-api/v1/tweets/post-and-engage/api-reference/get-statuses-show-id
  def self.remove_media_urls_in_status(status, text)
    medias = get_medias(status)

    return text if medias.empty?

    medias.each_with_object(text.dup) do |media, t|
      t.gsub!(media["url"], "")
      t.strip!
    end
  end

  # @param status [Hash] Response of `GET statuses/show/:id`
  # @return [Array<Hash>]
  # @see https://developer.x.com/en/docs/x-api/v1/tweets/post-and-engage/api-reference/get-statuses-show-id
  def self.get_medias(status)
    # TODO: Check extended_entities.media
    status.dig("entities", "media") || []
  end
  private_class_method :get_medias
end
