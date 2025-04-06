# frozen_string_literal: true

require "test_helper"

class ApplicationHealthControllerTest < ActionDispatch::IntegrationTest
  test "/application_health/boot" do
    get "/application_health/boot"
    assert_response :ok
  end

  test "/application_health/db" do
    get "/application_health/db"
    assert_response :ok
  end

  test "/application_health/wafris" do
    get "/application_health/wafris"
    assert_response :internal_server_error
  end

  test "/application_health/boot: failure because bad DB connection" do
    Spy.on(ActiveRecord::Base, "connected?" => false)
    get "/application_health/db"
    assert_response :internal_server_error
  end
end