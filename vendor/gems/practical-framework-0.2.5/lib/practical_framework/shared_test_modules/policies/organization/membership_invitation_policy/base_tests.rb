# frozen_string_literal: true

module PracticalFramework::SharedTestModules::Policies::Organization::MembershipInvitationPolicy::BaseTests
  extend ActiveSupport::Concern
  included do
    def assert_can_manage(invitation:, user:)
      assert_equal true, policy_for(invitation: invitation, user: user).apply(:manage?)
    end

    def assert_cannot_manage(invitation:, user:)
      assert_equal false, policy_for(invitation: invitation, user: user).apply(:manage?)
    end

    test "manage?: only true for memberships where the user has an organization_manager membership for the same organization" do
      invitation = organizations.organization_1.membership_invitations.create!(
        email: Faker::Internet.email,
        sender: users.organization_1_owner,
        membership_type: :staff
      )

      assert_equal true, policy_for(invitation: invitation, user: users.organization_1_owner).apply(:manage?)
      assert_equal true, policy_for(invitation: invitation, user: users.organization_1_department_head).apply(:manage?)

      assert_equal false, policy_for(invitation: invitation, user: users.moonlighter).apply(:manage?)
      assert_equal false, policy_for(invitation: invitation, user: users.retired_department_head).apply(:manage?)
      assert_equal false, policy_for(invitation: invitation, user: users.organization_2_owner).apply(:manage?)
      assert_equal false, policy_for(invitation: invitation, user: users.apprentice).apply(:manage?)
      assert_equal false, policy_for(invitation: invitation, user: users.retired_staff).apply(:manage?)
    end

    test "archive?: false if the user does not have an organization_manager membership in the same organization" do
      invitation = organizations.organization_1.membership_invitations.create!(
        email: Faker::Internet.email,
        sender: users.organization_1_owner,
        membership_type: :staff
      )

      assert_equal true, policy_for(invitation: invitation, user: users.organization_1_owner).apply(:archive?)
      assert_equal true, policy_for(invitation: invitation, user: users.organization_1_department_head).apply(:archive?)

      assert_equal false, policy_for(invitation: invitation, user: users.moonlighter).apply(:archive?)
      assert_equal false, policy_for(invitation: invitation, user: users.retired_department_head).apply(:archive?)
      assert_equal false, policy_for(invitation: invitation, user: users.organization_2_owner).apply(:archive?)
      assert_equal false, policy_for(invitation: invitation, user: users.apprentice).apply(:archive?)
      assert_equal false, policy_for(invitation: invitation, user: users.retired_staff).apply(:archive?)
    end

    test "relation only returns the membership_invitations that are part of the same organization" do
      organizations.organization_1.membership_invitations.create!(
        email: Faker::Internet.email,
        sender: users.organization_1_owner,
        membership_type: :staff
      )

      organizations.organization_2.membership_invitations.create!(
        email: Faker::Internet.email,
        sender: users.organization_2_owner,
        membership_type: :staff
      )

      assert_equal_set(
        organizations.organization_1.membership_invitations,
        relation_policy_for(
          organization: organizations.organization_1,
          user: users.organization_1_department_head
        ).apply_scope(all_membership_invitations_relation, type: :active_record_relation)
      )

      assert_equal_set(
        organizations.organization_2.membership_invitations,
        relation_policy_for(
          organization: organizations.organization_2,
          user: users.organization_2_owner
        ).apply_scope(all_membership_invitations_relation, type: :active_record_relation)
      )

      assert_equal_set(
        organizations.organization_1.membership_invitations,
        relation_policy_for(
          organization: organizations.organization_1,
          user: users.moonlighter
        ).apply_scope(all_membership_invitations_relation, type: :active_record_relation)
      )

      assert_empty(
        relation_policy_for(
          organization: organizations.organization_1,
          user: users.organization_2_owner
        ).apply_scope(all_membership_invitations_relation, type: :active_record_relation)
      )
    end
  end
end