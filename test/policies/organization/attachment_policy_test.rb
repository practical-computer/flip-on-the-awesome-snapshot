# frozen_string_literal: true

require "test_helper"

class Organization::AttachmentPolicyTest < ActiveSupport::TestCase
  include PracticalFramework::TestHelpers::ShrineTestData
  include PracticalFramework::SharedTestModules::Policies::OrganizationResourcePolicy::InheritsFromOrganizationResourcePolicyTests

  def policy_for(user:, organization:)
    Organization::AttachmentPolicy.new(nil, user: user, organization: organization)
  end

  def policy_class
    Organization::AttachmentPolicy
  end

  def resource_policy_class
    OrganizationResourcePolicy
  end

  test "create?: only true if the OrganizationPolicy.show? is true" do
    assert_equal true, policy_for(user: users.moonlighter, organization: organizations.organization_1).apply(:create?)
    assert_equal true, policy_for(user: users.organization_1_department_head, organization: organizations.organization_1).apply(:create?)


    assert_equal true, policy_for(user: users.moonlighter, organization: organizations.organization_2).apply(:create?)
    assert_equal false, policy_for(user: users.organization_1_department_head, organization: organizations.organization_2).apply(:create?)

    assert_equal false, policy_for(user: users.retired_staff, organization: organizations.organization_1).apply(:create?)
    assert_equal false, policy_for(user: users.retired_department_head, organization: organizations.organization_1).apply(:create?)
  end

  test "relation only returns the attachments that are part of the same organization" do
    attachment_1 = organizations.organization_1.attachments.create!(attachment: csv_file, user: users.organization_1_owner)
    attachment_2 = organizations.organization_2.attachments.create!(attachment: csv_file, user: users.moonlighter)
    attachment_2 = organizations.organization_1.attachments.create!(attachment: csv_file, user: users.moonlighter)

    assert_equal_set(
      organizations.organization_1.attachments,
      policy_for(
        user: users.organization_1_department_head,
        organization: organizations.organization_1
      ).apply_scope(Organization::Attachment.all, type: :active_record_relation)
    )

    assert_equal_set(
      organizations.organization_2.attachments,
      policy_for(
        user: users.organization_2_owner,
        organization: organizations.organization_2
      ).apply_scope(Organization::Attachment.all, type: :active_record_relation)
    )

    assert_empty(
      policy_for(
        user: users.organization_1_owner,
        organization: organizations.organization_2
      ).apply_scope(Organization::Attachment.all, type: :active_record_relation)
    )
  end
end