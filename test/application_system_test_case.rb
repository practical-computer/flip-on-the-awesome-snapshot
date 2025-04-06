# frozen_string_literal: true

require "test_helper"
require 'capybara-screenshot/minitest'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include PracticalFramework::TestHelpers::SystemTestAssertions
  include PracticalFramework::TestHelpers::PasskeySystemTestHelpers::RackTest
  include PracticalFramework::TestHelpers::CapybaraTestPrep

  driven_by :rack_test
end


class SlowBrowserSystemTestCase < ApplicationSystemTestCase
  include PracticalFramework::TestHelpers::PasskeySystemTestHelpers::Selenium
  include PracticalFramework::TestHelpers::PracticalEditorHelpers

  setup do
    admin_uri = URI.parse("https://admin.#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}")
    Spy.on(AppSettings, admin_relying_party_origin: admin_uri.to_s)

    default_uri = URI.parse("https://#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}")
    Spy.on(AppSettings, relying_party_origin: default_uri.to_s)
    Spy.on_instance_method(ActionController::Base, allow_forgery_protection: true)
  end

  driven_by :selenium, using: :chrome, screen_size: [1400, 1400] do |options|
    options.accept_insecure_certs = true
    if ENV.has_key?("HEADLESS_TESTS")
      options.args << "--headless=new"
    else
      options.args << "--auto-open-devtools-for-tabs"
    end
  end

  def skip_because_old_ui?
    skip "NEED TO SKIP UNTIL FRONTEND IS REBUILT" if Date.today < Date.new(2025, 5, 1)
  end

  def assert_toast_message(text:)
    within(".notification-messages") do
      assert_selector("dialog", text: text, visible: false)
    end
  end
end
