# frozen_string_literal: true

module PracticalFramework::SharedTestModules::Policies::Organization::MembershipPolicy::BaseTests
  extend ActiveSupport::Concern
  included do
    test "manage?: only true for memberships where the user has an organization_manager membership for the same organization" do
      membership = users.moonlighter.memberships.find_by(organization: organizations.organization_1)

      assert_equal true, policy_for(membership: membership, user: users.organization_1_owner).apply(:manage?)
      assert_equal true, policy_for(membership: membership, user: users.organization_1_department_head).apply(:manage?)

      assert_equal false, policy_for(membership: membership, user: users.moonlighter).apply(:manage?)
      assert_equal false, policy_for(membership: membership, user: users.retired_department_head).apply(:manage?)
      assert_equal false, policy_for(membership: membership, user: users.organization_2_owner).apply(:manage?)
      assert_equal false, policy_for(membership: membership, user: users.apprentice).apply(:manage?)
      assert_equal false, policy_for(membership: membership, user: users.retired_staff).apply(:manage?)
    end

    test "archive?: false if the user does not have an organization_manager membership in the same organization" do
      membership = users.moonlighter.memberships.find_by(organization: organizations.organization_1)

      assert_equal true, policy_for(membership: membership, user: users.organization_1_owner).apply(:archive?)
      assert_equal true, policy_for(membership: membership, user: users.organization_1_department_head).apply(:archive?)

      assert_equal false, policy_for(membership: membership, user: users.moonlighter).apply(:archive?)
      assert_equal false, policy_for(membership: membership, user: users.retired_department_head).apply(:archive?)
      assert_equal false, policy_for(membership: membership, user: users.organization_2_owner).apply(:archive?)
      assert_equal false, policy_for(membership: membership, user: users.apprentice).apply(:archive?)
      assert_equal false, policy_for(membership: membership, user: users.retired_staff).apply(:archive?)
    end

    test "archive?: true if the membership is not an organization_manager membership" do
      membership = users.moonlighter.memberships.find_by(organization: organizations.organization_1)

      assert_equal false, membership.organization_manager?

      assert_equal true, policy_for(membership: membership, user: users.organization_1_owner).apply(:archive?)
      assert_equal true, policy_for(membership: membership, user: users.organization_1_department_head).apply(:archive?)

      assert_equal false, policy_for(membership: membership, user: users.moonlighter).apply(:archive?)
      assert_equal false, policy_for(membership: membership, user: users.retired_department_head).apply(:archive?)
      assert_equal false, policy_for(membership: membership, user: users.organization_2_owner).apply(:archive?)
      assert_equal false, policy_for(membership: membership, user: users.apprentice).apply(:archive?)
      assert_equal false, policy_for(membership: membership, user: users.retired_staff).apply(:archive?)
    end

    test "archive?: only true if the organization_manager membership can be removed" do
      membership = users.organization_1_department_head.memberships.find_by(organization: organizations.organization_1)

      assert_equal true, membership.organization_manager?
      assert_equal true, organization_policy(membership.organization, user: users.organization_1_owner).apply(:remove_organization_manager?)

      assert_equal true, policy_for(membership: membership, user: users.organization_1_owner).apply(:archive?)
      assert_equal true, policy_for(membership: membership, user: users.organization_1_department_head).apply(:archive?)

      assert_equal false, policy_for(membership: membership, user: users.moonlighter).apply(:archive?)
      assert_equal false, policy_for(membership: membership, user: users.retired_department_head).apply(:archive?)
      assert_equal false, policy_for(membership: membership, user: users.organization_2_owner).apply(:archive?)
      assert_equal false, policy_for(membership: membership, user: users.apprentice).apply(:archive?)
      assert_equal false, policy_for(membership: membership, user: users.retired_staff).apply(:archive?)

      other_membership = users.organization_2_owner.memberships.find_by(organization: organizations.organization_2)
      assert_equal true, membership.organization_manager?
      assert_equal false, organization_policy(other_membership.organization, user: users.organization_2_owner).apply(:remove_organization_manager?)

      assert_equal false, policy_for(membership: membership, user: users.organization_2_owner).apply(:archive?)
    end

    test "relation only returns the memberships that are part of the same organization" do
      assert_equal_set(
        organizations.organization_1.memberships,
        policy_for(
          membership: users.moonlighter.memberships.find_by(organization: organizations.organization_1),
          user: users.organization_1_department_head
        ).apply_scope(all_memberships_relation, type: :active_record_relation)
      )

      assert_equal_set(
        organizations.organization_2.memberships,
        policy_for(
          membership: users.moonlighter.memberships.find_by(organization: organizations.organization_2),
          user: users.organization_2_owner
        ).apply_scope(all_memberships_relation, type: :active_record_relation)
      )

      assert_equal_set(
        organizations.organization_1.memberships,
        policy_for(
          membership: users.moonlighter.memberships.find_by(organization: organizations.organization_1),
          user: users.moonlighter
        ).apply_scope(all_memberships_relation, type: :active_record_relation)
      )

      assert_empty(
        policy_for(
          membership: users.moonlighter.memberships.find_by(organization: organizations.organization_1),
          user: users.organization_2_owner
        ).apply_scope(all_memberships_relation, type: :active_record_relation)
      )
    end
  end
end