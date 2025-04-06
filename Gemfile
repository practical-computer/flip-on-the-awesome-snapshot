# frozen_string_literal: true

require 'date'

# until Ruby 3.4 is released
# Needed until Ruby 3.3.4 is released https://github.com/ruby/ruby/pull/11006
gem 'net-pop', github: 'ruby/net-pop'

source "https://rubygems.org"

ruby file: '.ruby-version'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8"

gem "propshaft"

gem 'pg'

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

gem "aws-sdk-s3", "~> 1.177.0"

# Use Redis adapter to run Action Cable in production
gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i( windows jruby )

gem "font-awesome-helpers", path: "vendor/gems"
gem "practical-framework", path: "vendor/gems"

gem "flipper"
gem "flipper-active_record"
gem 'flipper-ui'

gem "administrate"

gem "postmark-rails"

gem 'rack-cors'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i( mri windows )
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem 'capybara-lockstep'
  gem 'capybara-screenshot'
  gem "minitest-ci", require: false
  gem 'rails-dom-testing'
  gem "selenium-webdriver"
  gem 'simplecov', require: false
  gem "spy"
  gem "timecop"
end

gem "dartsass-rails"
gem 'device_detector'
gem "devise-passkeys"
gem "loaf"
gem "oaken", github: "kaspth/oaken", branch: "main"
gem "pagy"
gem "phlex-rails", "< 2"
gem "shrine"
gem "warden-webauthn", github: "ruby-passkeys/warden-webauthn", branch: "thomas/2024-03-30-configurable-authentication-user-verification"

group :development do
  gem 'brakeman'
  gem "lookbook"
end

group :development, :test do
  gem "i18n-debug"
  gem 'rubocop-capybara', require: false
  gem 'rubocop-minitest', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem "rubocop-rails-omakase", require: false
  gem 'rubocop-rubycw', require: false
end

group :test do
  gem "faker"
  gem "localhost"
  gem "phlex-testing-capybara", "~> 0.1.0"
  gem "phlex-testing-nokogiri", "~> 0.1.0"
end

gem "action_policy"
gem "benchmark-ips", group: [:development, :test]
gem "dotenv-rails", require: 'dotenv/load'

group :production do
  gem "rails_semantic_logger"
  gem 'wafris'
end

gem "bundler-audit", "~> 0.9.1"

gem "dockerfile-rails", ">= 1.6", group: :development

gem "good_job", "~> 4.9"

gem "honeybadger", "~> 5.8"

gem "httpx", "~> 1.2"

gem "duck-hunt", "~> 0.1.0"

gem "rack-mini-profiler"
# For memory profiling
gem 'memory_profiler'

# For call-stack profiling flamegraphs
gem 'stackprof'

gem "ostruct"
gem "view_component", "~> 3.21"
