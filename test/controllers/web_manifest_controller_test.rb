# frozen_string_literal: true

require "test_helper"

class WebManifestControllerTest < ActionDispatch::IntegrationTest
  test "should get manifest" do
    get web_manifest_url
    assert_response :success
  end

  test "should get admin manifest" do
    get admin_web_manifest_url
    assert_response :success
  end
end
