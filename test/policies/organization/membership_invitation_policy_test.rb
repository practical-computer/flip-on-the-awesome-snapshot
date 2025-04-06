# frozen_string_literal: true

require "test_helper"

class Organization::MembershipInvitationPolicyTest < ActiveSupport::TestCase
  include PracticalFramework::SharedTestModules::Policies::Organization::MembershipInvitationPolicy::BaseTests

  def policy_for(invitation:, user:)
    Organization::MembershipInvitationPolicy.new(invitation, organization: invitation.organization, user: user)
  end

  def relation_policy_for(organization:, user:)
    Organization::MembershipInvitationPolicy.new(nil, organization: organization, user: user)
  end

  def all_membership_invitations_relation
    MembershipInvitation.all
  end
end