# frozen_string_literal: true

require 'semantic_logger'

class PracticalFramework::HoneybadgerSemanticLoggerAppender
  def self.create
    appender = SemanticLogger::Appender::Http.new(
      url: "https://api.honeybadger.io/v1/events"
    )

    appender.header["X-API-Key"] = AppSettings.honeybadger_api_key
    appender.header["User-Agent"] = "Custom Semantic Logger; #{RUBY_VERSION}; #{RUBY_PLATFORM}".freeze

    return appender
  end
end