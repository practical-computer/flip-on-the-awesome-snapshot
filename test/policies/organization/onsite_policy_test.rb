# frozen_string_literal: true

require "test_helper"

class Organization::OnsiteolicyTest < ActiveSupport::TestCase
  include PracticalFramework::SharedTestModules::Policies::OrganizationResourcePolicy::InheritsFromOrganizationResourcePolicyTests

  def policy_for(user:, onsite:, organization:)
    Organization::OnsitePolicy.new(onsite, user: user, organization: organization)
  end

  def relation_policy_for(user:, organization:)
    Organization::OnsitePolicy.new(nil, user: user, organization: organization)
  end

  def policy_class
    Organization::OnsitePolicy
  end

  def resource_policy_class
    OrganizationResourcePolicy
  end

  alias_method :create_policy_for, :relation_policy_for

  test "manage?: only true if the JobPolicy.show? is true" do
    onsite = organization_onsites.repeat_onsite_1
    assert_equal true, policy_for(onsite: onsite, user: users.moonlighter, organization: organizations.organization_1).apply(:manage?)
    assert_equal true, policy_for(onsite: onsite, user: users.organization_1_department_head, organization: organizations.organization_1).apply(:manage?)


    assert_equal false, policy_for(onsite: onsite, user: users.moonlighter, organization: organizations.organization_2).apply(:manage?)
    assert_equal false, policy_for(onsite: onsite, user: users.organization_1_department_head, organization: organizations.organization_2).apply(:manage?)

    assert_equal false, policy_for(onsite: onsite, user: users.retired_staff, organization: organizations.organization_1).apply(:manage?)
    assert_equal false, policy_for(onsite: onsite, user: users.retired_department_head, organization: organizations.organization_1).apply(:manage?)
  end

  test "create?: only true if the JobPolicy.show? is true" do
    assert_equal true, create_policy_for(user: users.moonlighter, organization: organizations.organization_1).apply(:create?)
    assert_equal true, create_policy_for(user: users.organization_1_department_head, organization: organizations.organization_1).apply(:create?)

    assert_equal true, create_policy_for(user: users.moonlighter, organization: organizations.organization_2).apply(:create?)
    assert_equal false, create_policy_for(user: users.organization_1_department_head, organization: organizations.organization_2).apply(:create?)

    assert_equal false, create_policy_for(user: users.retired_staff, organization: organizations.organization_1).apply(:create?)
    assert_equal false, create_policy_for(user: users.retired_department_head, organization: organizations.organization_1).apply(:create?)
  end

  test "relation only returns the jobs that are part of the same organization" do
    assert_equal_set(
      organizations.organization_1.onsites,
      relation_policy_for(
        user: users.organization_1_department_head,
        organization: organizations.organization_1
      ).apply_scope(Organization::Onsite.all, type: :active_record_relation)
    )

    assert_equal_set(
      organizations.organization_2.onsites,
      relation_policy_for(
        user: users.organization_2_owner,
        organization: organizations.organization_2
      ).apply_scope(Organization::Onsite.all, type: :active_record_relation)
    )

    assert_empty(
      relation_policy_for(
        user: users.organization_1_owner,
        organization: organizations.organization_2
      ).apply_scope(Organization::Onsite.all, type: :active_record_relation)
    )
  end
end