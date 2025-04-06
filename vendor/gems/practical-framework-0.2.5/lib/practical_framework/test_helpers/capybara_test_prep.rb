# frozen_string_literal: true

module PracticalFramework::TestHelpers::CapybaraTestPrep
  extend ActiveSupport::Concern
  included do
    Capybara.save_path = Rails.root.join("tmp", "capybara").to_s
    Capybara.server_host = AppSettings.default_host
    Capybara.server = :puma, { Host: "ssl://#{Capybara.server_host}"}
  end
end