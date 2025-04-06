# frozen_string_literal: true

require "test_helper"

class Organization::JobPolicyTest < ActiveSupport::TestCase
  include PracticalFramework::SharedTestModules::Policies::OrganizationResourcePolicy::InheritsFromOrganizationResourcePolicyTests

  def policy_for(user:, job:, organization:)
    Organization::JobPolicy.new(job, user: user, organization: organization)
  end

  def relation_policy_for(user:, organization:)
    Organization::JobPolicy.new(nil, user: user, organization: organization)
  end

  def policy_class
    Organization::JobPolicy
  end

  def resource_policy_class
    OrganizationResourcePolicy
  end

  alias_method :create_policy_for, :relation_policy_for

  test "manage?: only true if the OrganizationPolicy.show? is true & the organization matches the job's organization" do
    job = organization_jobs.repeat_customer
    assert_equal true, policy_for(job: job, user: users.moonlighter, organization: organizations.organization_1).apply(:manage?)
    assert_equal true, policy_for(job: job, user: users.organization_1_department_head, organization: organizations.organization_1).apply(:manage?)

    assert_equal false, policy_for(job: job, user: users.moonlighter, organization: organizations.organization_2).apply(:manage?)
    assert_equal false, policy_for(job: job, user: users.organization_1_department_head, organization: organizations.organization_2).apply(:manage?)

    assert_equal false, policy_for(job: job, user: users.retired_staff, organization: organizations.organization_1).apply(:manage?)
    assert_equal false, policy_for(job: job, user: users.retired_department_head, organization: organizations.organization_1).apply(:manage?)
  end

  test "create?: only true if the OrganizationPolicy.show? is true" do
    assert_equal true, create_policy_for(user: users.moonlighter, organization: organizations.organization_1).apply(:create?)
    assert_equal true, create_policy_for(user: users.organization_1_department_head, organization: organizations.organization_1).apply(:create?)

    assert_equal true, create_policy_for(user: users.moonlighter, organization: organizations.organization_2).apply(:create?)
    assert_equal false, create_policy_for(user: users.organization_1_department_head, organization: organizations.organization_2).apply(:create?)

    assert_equal false, create_policy_for(user: users.retired_staff, organization: organizations.organization_1).apply(:create?)
    assert_equal false, create_policy_for(user: users.retired_department_head, organization: organizations.organization_1).apply(:create?)
  end

  test "manage_onsites?/manage_tasks?: only true if manage? is true and the job is not archived, returning archived_job as a failure reason" do
    user = users.moonlighter
    organization = organizations.organization_1
    other_organization = organizations.organization_2

    active_job = organization_jobs.repeat_customer
    archived_job = organization_jobs.archived_job

    policy = Organization::JobPolicy.new(active_job, user: user, organization: organization)
    assert_equal true, policy.apply(:manage_onsites?)
    assert_equal true, policy.apply(:manage_tasks?)

    policy = Organization::JobPolicy.new(active_job, user: user, organization: other_organization)
    assert_equal false, policy.apply(:manage_onsites?)
    assert_equal false, policy.apply(:manage_tasks?)


    policy = Organization::JobPolicy.new(archived_job, user: user, organization: organization)
    assert_equal false, policy.apply(:manage_onsites?)
    assert_equal [:archived_job], policy.result.reasons.details[:"organization/job"]

    policy = Organization::JobPolicy.new(archived_job, user: user, organization: organization)
    assert_equal false, policy.apply(:manage_tasks?)
    assert_equal [:archived_job], policy.result.reasons.details[:"organization/job"]

    policy = Organization::JobPolicy.new(archived_job, user: user, organization: other_organization)
    assert_equal false, policy.apply(:manage_onsites?)
    assert_empty policy.result.reasons

    policy = Organization::JobPolicy.new(archived_job, user: user, organization: other_organization)
    assert_equal false, policy.apply(:manage_tasks?)
    assert_empty policy.result.reasons
  end

  test "relation only returns the jobs that are part of the same organization" do
    assert_equal_set(
      organizations.organization_1.jobs,
      relation_policy_for(
        user: users.organization_1_department_head,
        organization: organizations.organization_1
      ).apply_scope(Organization::Job.all, type: :active_record_relation)
    )

    assert_equal_set(
      organizations.organization_2.jobs,
      relation_policy_for(
        user: users.organization_2_owner,
        organization: organizations.organization_2
      ).apply_scope(Organization::Job.all, type: :active_record_relation)
    )

    assert_empty(
      relation_policy_for(
        user: users.organization_1_owner,
        organization: organizations.organization_2
      ).apply_scope(Organization::Job.all, type: :active_record_relation)
    )
  end
end