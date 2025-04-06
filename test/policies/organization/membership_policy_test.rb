# frozen_string_literal: true

require "test_helper"

class Organization::MembershipPolicyTest < ActiveSupport::TestCase
  include PracticalFramework::SharedTestModules::Policies::OrganizationResourcePolicy::InheritsFromOrganizationResourcePolicyTests
  include PracticalFramework::SharedTestModules::Policies::Organization::MembershipPolicy::BaseTests

  def policy_for(membership:, user:)
    Organization::MembershipPolicy.new(membership, user: user, organization: membership.organization)
  end

  def policy_class
    Organization::MembershipPolicy
  end

  def resource_policy_class
    OrganizationResourcePolicy
  end

  def organization_policy(organization, user:)
    OrganizationPolicy.new(organization, user: user)
  end

  def all_memberships_relation
    Membership.all
  end
end