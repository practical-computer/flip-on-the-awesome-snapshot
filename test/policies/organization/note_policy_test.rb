# frozen_string_literal: true

require "test_helper"

class Organization::NotePolicyPolicyTest < ActiveSupport::TestCase
  include PracticalFramework::SharedTestModules::Policies::OrganizationResourcePolicy::InheritsFromOrganizationResourcePolicyTests

  def policy_for(user:, organization:, note:)
    Organization::NotePolicy.new(note, user: user, organization: organization)
  end

  def relation_policy_for(user:, organization:)
    Organization::NotePolicy.new(nil, user: user, organization: organization)
  end

  def policy_class
    Organization::NotePolicy
  end

  def resource_policy_class
    OrganizationResourcePolicy
  end

  alias_method :create_policy_for, :relation_policy_for

  test "create?: only true if the OrganizationPolicy.show? is true" do
    organization_1 = organizations.organization_1
    organization_2 = organizations.organization_2

    user_organization_1_only = users.organization_1_owner
    user_organization_2_only = users.organization_2_owner
    user_both_organizations = users.moonlighter
    archived_member = users.retired_staff
    archived_admin = users.retired_department_head

    assert_equal true, create_policy_for(user: user_organization_1_only, organization: organization_1).apply(:create?)
    assert_equal true, create_policy_for(user: user_both_organizations, organization: organization_1).apply(:create?)

    assert_equal true,  create_policy_for(user: user_both_organizations, organization: organization_2).apply(:create?)
    assert_equal false, create_policy_for(user: user_organization_1_only, organization: organization_2).apply(:create?)

    assert_equal false, create_policy_for(user: archived_admin, organization: organization_1).apply(:create?)
    assert_equal false, create_policy_for(user: archived_member, organization: organization_1).apply(:create?)
  end

  test "manage?: checks the instance provided" do
    seed "cases/note_editing"

    organization_1 = organizations.organization_1
    organization_2 = organizations.organization_2

    user_organization_1_only = users.organization_1_owner
    user_organization_2_only = users.organization_2_owner
    user_both_organizations = users.moonlighter
    archived_member = users.retired_staff
    archived_admin = users.retired_department_head

    note_for_organization_1 = organization_notes.organization_1_note
    note_for_organization_2 = organization_notes.organization_2_note

    assert_equal true, policy_for(note: note_for_organization_1, user: user_organization_1_only, organization: organization_1).apply(:manage?)
    assert_equal true, policy_for(note: note_for_organization_1, user: user_both_organizations, organization: organization_1).apply(:manage?)

    assert_equal true,  policy_for(note: note_for_organization_2, user: user_both_organizations, organization: organization_2).apply(:manage?)
    assert_equal false, policy_for(note: note_for_organization_2, user: user_organization_1_only, organization: organization_2).apply(:manage?)

    assert_equal false, policy_for(note: note_for_organization_1, user: archived_admin, organization: organization_1).apply(:manage?)
    assert_equal false, policy_for(note: note_for_organization_1, user: archived_member, organization: organization_1).apply(:manage?)
  end

  test "relation only returns the notes that are part of the same organization" do
    organization_1 = organizations.organization_1
    organization_2 = organizations.organization_2

    user_organization_1_only = users.organization_1_owner
    user_organization_2_only = users.organization_2_owner
    user_both_organizations = users.moonlighter

    assert_equal_set(
      organization_1.notes,
      relation_policy_for(
        user: user_organization_1_only,
        organization: organization_1
      ).apply_scope(Organization::Note.all, type: :active_record_relation)
    )

    assert_equal_set(
      organization_2.notes,
      relation_policy_for(
        user: user_organization_2_only,
        organization: organization_2
      ).apply_scope(Organization::Note.all, type: :active_record_relation)
    )

    assert_equal_set(
      organization_2.notes,
      relation_policy_for(
        user: user_both_organizations,
        organization: organization_2
      ).apply_scope(Organization::Note.all, type: :active_record_relation)
    )

    assert_empty(
      relation_policy_for(
        user: user_organization_1_only,
        organization: organization_2
      ).apply_scope(Organization::Note.all, type: :active_record_relation)
    )
  end
end