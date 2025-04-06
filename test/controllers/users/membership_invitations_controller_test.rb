# frozen_string_literal: true

require "test_helper"

class Users::MembershipInvitationsControllerTest < ActionDispatch::IntegrationTest
  include ActionMailer::TestHelper
  include PracticalFramework::SharedTestModules::Controllers::Users::MembershipInvitationsController::BaseTests

  def assert_policies_applied(user:, membership_invitation:, &block)
    assert_have_authorized_scope(type: :active_record_relation, with: User::MembershipInvitationPolicy) do
    assert_authorized_to(:manage?, user, with: UserPolicy) do
      assert_authorized_to(:manage?, membership_invitation, with: User::MembershipInvitationPolicy, &block)
    end
    end
  end

  def assert_policies_applied_on_404(user:, &block)
    assert_have_authorized_scope(type: :active_record_relation, with: User::MembershipInvitationPolicy, &block)
  end
end