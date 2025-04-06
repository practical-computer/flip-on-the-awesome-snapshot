# frozen_string_literal: true

require "test_helper"

class Organization::MembershipInvitationsControllerTest < ActionDispatch::IntegrationTest
  include ActionMailer::TestHelper
  include PracticalFramework::SharedTestModules::Controllers::Organizations::MembershipInvitationsController::BaseTests

  def assert_policies_applied(organization:, membership_invitation:, &block)
    assert_have_authorized_scope(type: :active_record_relation, with: Organization::MembershipInvitationPolicy) do
    assert_authorized_to(:manage?, organization, with: OrganizationPolicy) do
      assert_authorized_to(:manage?, membership_invitation, with: Organization::MembershipInvitationPolicy, &block)
    end
    end
  end

  def assert_policies_applied_on_404(organization:, &block)
    assert_have_authorized_scope(type: :active_record_relation, with: Organization::MembershipInvitationPolicy, &block)
  end
end