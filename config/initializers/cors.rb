# frozen_string_literal: true

# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins { |source, env| AppSettings.cors_origins.include?(source) }

    resource '/assets/*', headers: :any, methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
