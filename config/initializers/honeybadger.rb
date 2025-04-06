# frozen_string_literal: true

# i.e. config/initializers/honeybadger.rb
Honeybadger.configure do |config|
  config.env = AppSettings.app_env
  config.api_key = AppSettings.honeybadger_api_key
  config.root = Rails.root.to_s
  config.insights.enabled = true
end