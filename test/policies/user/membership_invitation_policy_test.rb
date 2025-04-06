# frozen_string_literal: true

require "test_helper"

class User::MembershipInvitationPolicyTest < ActiveSupport::TestCase
  include PracticalFramework::SharedTestModules::Policies::User::MembershipInvitationPolicy::BaseTests

  def policy_for(invitation:, user:)
    User::MembershipInvitationPolicy.new(invitation, user: user)
  end

  def find_membership_invitation!(email:)
    MembershipInvitation.find_by!(email: email)
  end
end
