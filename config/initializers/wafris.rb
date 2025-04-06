# frozen_string_literal: true

# Create this file and add the following:
# config/initializers/wafris.rb

if AppSettings.use_wafris?
  Wafris.configure do |c|
    c.redis = Redis.new(
      url: AppSettings.wafris_redis_url,
      timeout: 0.25,
      ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE },
    )
    c.redis_pool_size = 25
    c.quiet_mode = false
  end
end