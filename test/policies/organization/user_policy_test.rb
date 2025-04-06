# frozen_string_literal: true

require 'test_helper'

class Organization::UserPolicyTest < ActiveSupport::TestCase
  include PracticalFramework::SharedTestModules::Policies::OrganizationResourcePolicy::InheritsFromOrganizationResourcePolicyTests

  def relation_policy(organization:, user:)
    Organization::UserPolicy.new(organization, user: user, organization: organization).apply_scope(User.all, type: :active_record_relation)
  end

  def policy_class
    Organization::UserPolicy
  end

  def resource_policy_class
    OrganizationResourcePolicy
  end

  test "default relation only returns the users that has active memberships in the organization" do
    assert_equal_set(
      [users.organization_1_owner, users.organization_1_department_head, users.moonlighter],
      relation_policy(organization: organizations.organization_1, user: users.organization_1_owner)
    )

    assert_equal_set(
      [users.organization_2_owner, users.moonlighter],
      relation_policy(organization: organizations.organization_2, user: users.organization_2_owner)
    )

    assert_empty relation_policy(organization: organizations.organization_2, user: users.apprentice)
    assert_empty relation_policy(organization: organizations.organization_1, user: users.organization_2_owner)
    assert_empty relation_policy(organization: organizations.organization_2, user: users.organization_1_owner)
    assert_empty relation_policy(organization: organizations.organization_1, user: users.retired_staff)
    assert_empty relation_policy(organization: organizations.organization_2, user: users.retired_department_head)
  end
end