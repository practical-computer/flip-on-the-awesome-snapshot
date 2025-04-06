# frozen_string_literal: true

module PracticalFramework::TestHelpers::IntegrationTestAssertions
  def assert_error_json_contains(container_id:, element_id:, message:)
    found_message = response.parsed_body.find do |error_json|
      error_json["container_id"] == container_id &&
      error_json["element_id"] == element_id &&
      error_json["message"] == message
    end

    assert_not_nil found_message, response.parsed_body
  end

  def assert_json_redirected_to(location)
    assert_equal "322", response.code
    assert_equal location, response.parsed_body["location"]
  end

  def assert_error_dom(container_id:, message:)
    assert_dom("##{container_id}", text: message)
  end
end