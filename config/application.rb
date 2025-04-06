# frozen_string_literal: true

require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "rails/test_unit/railtie"

require_relative "../lib/railties/oaken"
require_relative "../lib/view_component/capture_compatibility_patch"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Dispatcher
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks generators templates practical_framework/tests railties/oaken.rb))

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.active_support.to_time_preserves_timezone = :zone

    config.active_job.queue_adapter = :good_job

    config.i18n.raise_on_missing_translations = true

    config.action_dispatch.tld_length = AppSettings.tld_length

    config.view_component.view_component_path = "app/views/components"
    config.eager_load_paths << Rails.root.join("app/views/components")
    config.view_component.generate.preview = true
    config.view_component.capture_compatibility_patch_enabled = true
    config.view_component.default_preview_layout = "component_preview"
    config.view_component.preview_controller = "CustomViewComponentsController"

    unless AppSettings.building_docker_image?
      config.asset_host = AppSettings.asset_host
      config.action_mailer.delivery_method = :postmark
      config.action_mailer.postmark_settings = { api_token: AppSettings.postmark_api_token }
    end

    if AppSettings.rails_semantic_logger_format
      config.rails_semantic_logger.format = AppSettings.rails_semantic_logger_format.to_sym
    end

    if AppSettings.log_to_std_out?
      $stdout.sync = true
      config.rails_semantic_logger.add_file_appender = false
      config.semantic_logger.add_appender(io: $stdout, formatter: config.rails_semantic_logger.format)
    end

    if AppSettings.log_to_honeybadger_insights?
      appender = PracticalFramework::HoneybadgerSemanticLoggerAppender.create

      config.semantic_logger.add_appender(appender: appender, formatter: config.rails_semantic_logger.format)
    end
  end
end

unless AppSettings.building_docker_image?
  Rails.application.default_url_options = AppSettings.default_url_options
end
