# frozen_string_literal: true

require 'debug'

unless File.exist?(".bundle/config")
  github_package_token = ask("What's your Github package token?")

  create_file ".bundle/config" do
    <<~TXT
    BUNDLE_RUBYGEMS__PKG__GITHUB__COM: "#{github_package_token}"
    TXT
  end
end

add_source "https://rubygems.pkg.github.com/practical-computer" do
  gem "better-importmaps"
  gem "font-awesome-helpers"
  gem "practical-framework"
end

gem "action_policy"
gem "administrate", "1.0.0.beta1"
gem "bundler-audit", "~> 0.9.1"
gem "dartsass-rails"
gem "device_detector"
gem "devise-passkeys"
gem "dockerfile-rails", ">= 1.6", group: :development
gem "dotenv-rails", require: 'dotenv/rails-now'
gem "duck-hunt", "~> 0.1.0"
gem "flipper"
gem "flipper-active_record"
gem "flipper-ui"
gem "good_job", "~> 3.27"
gem "honeybadger", "~> 5.8"
gem "httpx", "~> 1.2"
gem "loaf"
gem "memory_profiler"
gem "oaken", github: "kaspth/oaken", branch: "main"
gem "pagy"
gem "phlex-rails"
gem "postmark-rails"
gem "rack-cors"
gem "rack-mini-profiler"
gem "shrine"
gem "stackprof"
gem "warden-webauthn", github: "ruby-passkeys/warden-webauthn",
branch: "thomas/2024-03-30-configurable-authentication-user-verification"

gem_group :development do
  gem 'brakeman'
  gem "lookbook"
end

gem_group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "faker"
  gem "localhost"
  gem "minitest-ci", require: false
  gem "phlex-testing-capybara", "~> 0.1.0"
  gem "phlex-testing-nokogiri", "~> 0.1.0"
  gem "spy"
  gem "timecop"
  gem 'capybara-lockstep'
  gem 'capybara-screenshot'
  gem 'rails-dom-testing'
  gem 'simplecov', require: false
end

gem_group :production do
  gem "rails_semantic_logger"
  gem 'wafris'
end

gem_group :development, :test do
  gem "benchmark-ips"
  gem "i18n-debug"
  gem "rubocop-rails-omakase", require: false
  gem 'rubocop-capybara', require: false
  gem 'rubocop-minitest', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rubycw', require: false
end

run("bundle install")

rails_command("dartsass:install")
generate("good_job:install")
generate("devise:install")
generate("flipper:setup")

generate("practical_framework:dotenv")
FileUtils.cp(".env.local.template", ".env.local")

generate("practical_framework:app:environments")
insert_into_file "config/boot.rb", 'require_relative "../lib/app_settings"'
generate("practical_framework:app:locales")

generate("practical_framework:buildtools")
generate("practical_framework:bun")
generate("practical_framework:javascript")
generate("practical_framework:css")
generate("practical_framework:circleci")
generate("practical_framework:app:shrine")

generate("practical_framework:components")
generate("practical_framework:app:scaffold_models", "app")
generate("practical_framework:app:scaffold_policies")
generate("practical_framework:app:scaffold_services")
generate("practical_framework:app:scaffold_forms")
generate("practical_framework:app:scaffold_mailers")
generate("practical_framework:app:scaffold_relation_builders")

generate("practical_framework:app:scaffold_controllers")
generate("practical_framework:app:routes")

generate("practical_framework:generator_install")

generate("practical_framework:app:initializers")

generate("practical_framework:docker")
generate("practical_framework:dokku")