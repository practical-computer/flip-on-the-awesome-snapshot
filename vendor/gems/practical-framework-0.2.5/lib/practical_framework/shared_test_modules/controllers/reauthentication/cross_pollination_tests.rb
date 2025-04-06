# frozen_string_literal: true

module PracticalFramework::SharedTestModules::Controllers::Reauthentication::CrossPollinationTests
  extend ActiveSupport::Concern

  included do
    test "new_challenge: does not issue a challenge for another authenticated resource type" do
      sign_in_as_other_resource
      issue_new_challenge_action
      assert_response :not_found
    end

    test "reauthenticate: does not issue a challenge for another authenticated resource type" do
      sign_in_as_other_resource
      reauthenticate_action(params: {})
      assert_response :not_found
    end
  end
end