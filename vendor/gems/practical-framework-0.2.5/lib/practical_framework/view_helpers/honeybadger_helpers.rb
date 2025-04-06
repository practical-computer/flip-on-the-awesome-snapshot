# frozen_string_literal: true

module PracticalFramework::ViewHelpers::HoneybadgerHelpers
  def honeybadger_js_configuration
    {
      "apiKey" => AppSettings.honeybadger_js_api_key,
      "environment" => AppSettings.app_env,
      "revision" => AppSettings.app_revision
    }
  end
end