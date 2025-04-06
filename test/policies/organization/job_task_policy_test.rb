# frozen_string_literal: true

require "test_helper"

class Organization::JobTaskPolicyPolicyTest < ActiveSupport::TestCase
  include PracticalFramework::SharedTestModules::Policies::OrganizationResourcePolicy::InheritsFromOrganizationResourcePolicyTests

  def policy_for(user:, organization:, job_task:)
    Organization::JobTaskPolicy.new(job_task, user: user, organization: organization)
  end

  def relation_policy_for(user:, organization:)
    Organization::JobTaskPolicy.new(nil, user: user, organization: organization)
  end

  def policy_class
    Organization::JobTaskPolicy
  end

  def resource_policy_class
    OrganizationResourcePolicy
  end

  alias_method :create_policy_for, :relation_policy_for

  test "create?: only true if the OrganizationPolicy.show? is true" do
    organization_1 = organizations.organization_1
    organization_2 = organizations.organization_2

    user_organization_1_only = users.organization_1_department_head
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
    organization_1 = organizations.organization_1
    organization_2 = organizations.organization_2

    user_organization_1_only = users.organization_1_department_head
    user_organization_2_only = users.organization_2_owner
    user_both_organizations = users.moonlighter
    archived_member = users.retired_staff
    archived_admin = users.retired_department_head

    job_task_for_organization_1 = organization_job_tasks.todo_repeat_onsite_1
    job_task_for_organization_2 = organization_job_tasks.job_for_organization_2_onsite

    assert_equal true, policy_for(job_task: job_task_for_organization_1, user: user_organization_1_only, organization: organization_1).apply(:manage?)
    assert_equal true, policy_for(job_task: job_task_for_organization_1, user: user_both_organizations, organization: organization_1).apply(:manage?)

    assert_equal true,  policy_for(job_task: job_task_for_organization_2, user: user_both_organizations, organization: organization_2).apply(:manage?)
    assert_equal false, policy_for(job_task: job_task_for_organization_2, user: user_organization_1_only, organization: organization_2).apply(:manage?)

    assert_equal false, policy_for(job_task: job_task_for_organization_1, user: archived_admin, organization: organization_1).apply(:manage?)
    assert_equal false, policy_for(job_task: job_task_for_organization_1, user: archived_member, organization: organization_1).apply(:manage?)
  end

  test "relation only returns the job_tasks that are part of the same organization" do
    organization_1 = organizations.organization_1
    organization_2 = organizations.organization_2

    user_organization_1_only = users.organization_1_department_head
    user_organization_2_only = users.organization_2_owner
    user_both_organizations = users.moonlighter

    assert_equal_set(
      organization_1.job_tasks,
      relation_policy_for(
        user: user_organization_1_only,
        organization: organization_1
      ).apply_scope(Organization::JobTask.all, type: :active_record_relation)
    )

    assert_equal_set(
      organization_2.job_tasks,
      relation_policy_for(
        user: user_organization_2_only,
        organization: organization_2
      ).apply_scope(Organization::JobTask.all, type: :active_record_relation)
    )

    assert_equal_set(
      organization_2.job_tasks,
      relation_policy_for(
        user: user_both_organizations,
        organization: organization_2
      ).apply_scope(Organization::JobTask.all, type: :active_record_relation)
    )

    assert_empty(
      relation_policy_for(
        user: user_organization_1_only,
        organization: organization_2
      ).apply_scope(Organization::JobTask.all, type: :active_record_relation)
    )
  end
end