# frozen_string_literal: true

class AppSettings
  def self.env_fetch(method_name:, key:)
    define_singleton_method(method_name){ ENV.fetch(key) }
  end

  env_fetch(method_name: :webserver_port, key: "PORT")
  env_fetch(method_name: :company_name, key: "COMPANY_NAME")
  env_fetch(method_name: :company_address, key: "COMPANY_ADDRESS")

  env_fetch(method_name: :app_name, key: "APP_NAME")
  env_fetch(method_name: :default_host, key: "DEFAULT_HOST")
  env_fetch(method_name: :asset_host, key: "ASSET_HOST")
  env_fetch(method_name: :relying_party_origin, key: "RELYING_PARTY_ORIGIN")

  env_fetch(method_name: :admin_host, key: "ADMIN_HOST")
  env_fetch(method_name: :admin_relying_party_origin, key: "ADMIN_RELYING_PARTY_ORIGIN")

  env_fetch(method_name: :support_url, key: "SUPPORT_URL")
  env_fetch(method_name: :support_email, key: "SUPPORT_EMAIL")

  env_fetch(method_name: :postmark_api_token, key: "POSTMARK_API_TOKEN")
  env_fetch(method_name: :google_places_js_api_key, key: "GOOGLE_PLACES_JS_API_KEY")
  env_fetch(method_name: :wafris_redis_url, key: "WAFRIS_REDIS_URL")
  env_fetch(method_name: :honeybadger_api_key, key: "HONEYBADGER_API_KEY")
  env_fetch(method_name: :honeybadger_js_api_key, key: "HONEYBADGER_JS_API_KEY")
  env_fetch(method_name: :posthog_session_token, key: "POSTHOG_SESSION_TOKEN")
  env_fetch(method_name: :redis_cache_url, key: "REDIS_CACHE_URL")

  env_fetch(method_name: :fontawesome_kit_code, key: "FONTAWESOME_KIT_CODE")

  def self.app_revision
    ENV.fetch("GIT_REV"){ nil }
  end

  def self.app_env
    ENV.fetch("APP_ENV"){ Rails.env }
  end

  def self.building_docker_image?
    ENV.fetch("BUILDING_DOCKER_IMAGE") { nil }
  end

  def self.rails_semantic_logger_format
    ENV.fetch("RAILS_SEMANTIC_LOGGER_FORMAT") { nil }
  end

  def self.log_to_std_out?
    ENV.fetch("RAILS_LOG_TO_STDOUT") { false }
  end

  def self.log_to_honeybadger_insights?
    ENV.fetch("RAILS_LOG_TO_HONEYBADGER_INSIGHTS") { false }
  end

  def self.tld_length
    Integer(ENV.fetch("TLD_LENGTH") { 1 })
  end

  def self.default_host_uri
    URI.parse("https://#{self.default_host}")
  end

  def self.use_s3_storage?
    ENV.has_key?("S3_ENDPOINT")
  end

  def self.posthog_session_recording?
    ENV.has_key?("POSTHOG_SESSION_TOKEN")
    Flipper.enabled?(:posthog_session_recording)
  end

  def self.shrine_s3_options
    {
      endpoint: ENV.fetch("S3_ENDPOINT"),
      bucket: ENV.fetch("S3_BUCKET_NAME"),
      region: ENV.fetch("S3_REGION"),
      access_key_id: ENV.fetch("S3_ACCESS_KEY_ID"),
      secret_access_key: ENV.fetch("S3_ACCESS_KEY_SECRET"),
    }
  end

  def self.cors_origins
    allowed = [default_host, admin_host, asset_host]
    allowed.map do |hostname|
      URI.parse("https://#{hostname}").to_s
    end
  end

  def self.use_wafris?
    ENV.has_key?("WAFRIS_REDIS_URL")
  end

  def self.use_redis_cache?
    ENV.has_key?("REDIS_CACHE_URL")
  end

  def self.generate_uri(subdomain:)
    uri = default_host_uri
    uri.host = uri.host.prepend(subdomain.to_s, ".")
    return uri
  end

  def self.default_url_options
    { host: self.default_host, protocol: :https }
  end
end