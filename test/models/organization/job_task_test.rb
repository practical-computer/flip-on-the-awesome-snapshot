# frozen_string_literal: true

require "test_helper"

class Organization::JobTaskTest < ActiveSupport::TestCase
  def valid_new_job_task
    organization_jobs.repeat_customer.tasks.build(
      label: Faker::Hacker.say_something_smart,
      original_creator: users.organization_1_owner,
      onsite: organization_onsites.repeat_onsite_1,
      task_type: :onsite,
      status: :todo,
      estimated_minutes: 30
    )
  end

  test "belongs_to: original_creator" do
    reflection = Organization::JobTask.reflect_on_association(:original_creator)
    assert_equal :belongs_to, reflection.macro
    assert_equal "User", reflection.class_name
  end

  test "belongs_to: job" do
    reflection = Organization::JobTask.reflect_on_association(:job)
    assert_equal :belongs_to, reflection.macro
  end

  test "belongs_to: onsite optionally" do
    reflection = Organization::JobTask.reflect_on_association(:onsite)
    assert_equal :belongs_to, reflection.macro
    assert_equal true, reflection.options[:optional]
  end

  test "belongs_to: organization through job" do
    reflection = Organization::JobTask.reflect_on_association(:organization)
    assert_equal :has_one, reflection.macro
    assert_equal :job, reflection.options[:through]
  end

  test "label: must be present and non-blank" do
    instance = valid_new_job_task

    assert_equal true, instance.valid?
    instance.label = nil

    assert_equal false, instance.valid?
    assert_equal true, instance.errors.of_kind?(:label, :blank)

    instance.label = "    "

    assert_equal false, instance.valid?
    assert_equal true, instance.errors.of_kind?(:label, :blank)
  end

  test "label: must be unique for the job and onsite combination" do
    existing_job_task = organization_job_tasks.todo_repeat_onsite_1
    onsite = existing_job_task.onsite

    new_task = onsite.tasks.build(
      job: onsite.job,
      label: existing_job_task.label,
      original_creator: users.moonlighter
    )

    assert_equal false, new_task.valid?
    assert_equal true, new_task.errors.of_kind?(:label, :taken)

    new_task.label = Faker::Hacker.say_something_smart
    assert_equal true, new_task.valid?

    new_task.label = existing_job_task.label

    assert_equal false, new_task.valid?

    new_task.onsite = nil

    assert_equal true, new_task.valid?

    other_onsite = organization_onsites.repeat_onsite_2

    assert_equal true, new_task.valid?
  end

  test "validates that the original_creator has a membership in the organization on creation only" do
    new_task = valid_new_job_task

    other_user = users.organization_3_owner

    assert_not_includes other_user.organizations, new_task.organization

    new_task.original_creator = other_user

    assert_equal false, new_task.valid?
    assert_equal true, new_task.errors.of_kind?(:original_creator, :cannot_access_organization)

    new_task.original_creator = users.moonlighter
    assert_equal true, new_task.valid?

    new_task.original_creator = users.organization_1_department_head
    assert_equal true, new_task.valid?

    new_task.save!

    new_task.original_creator = users.organization_3_owner
    assert_equal true, new_task.valid?
  end

  test "validates that the onsite is for the job on both create and update" do
    new_task = valid_new_job_task
    old_onsite = new_task.onsite
    other_job = organization_jobs.other_job

    new_task.job = other_job

    assert_equal false, new_task.valid?
    assert_equal true, new_task.errors.of_kind?(:onsite, :not_in_job)

    new_task.job = organization_jobs.repeat_customer
    assert_equal true, new_task.valid?

    new_task.onsite = nil
    assert_equal true, new_task.valid?

    new_task.save!

    new_task.job = other_job
    new_task.onsite = old_onsite

    assert_equal false, new_task.valid?
    assert_equal true, new_task.errors.of_kind?(:onsite, :not_in_job)

    new_task.job = organization_jobs.repeat_customer
    assert_equal true, new_task.valid?
  end

  test "scannable_ordering: orders by status, then task_type, then label" do
    seed "cases/job_task_ordering"

    expected = [
      organization_job_tasks.todo_onsite_a,
      organization_job_tasks.todo_offsite_d,
      organization_job_tasks.done_onsite_b,
      organization_job_tasks.done_offsite_e,
      organization_job_tasks.cancelled_onsite_c,
      organization_job_tasks.cancelled_offsite_f,
    ]

    assert_equal expected, organizations.ordered_organization.job_tasks.scannable_ordering
  end
end


class Organization::JobTaskCachingTest < ActiveJob::TestCase
  test "queues up cache breaks when creating a record (no onsite)" do
    perform_enqueued_jobs

    job = organization_jobs.repeat_customer
    new_task = job.tasks.build(
      label: Faker::Hacker.say_something_smart,
      original_creator: users.organization_1_owner,
      onsite: nil,
      task_type: :onsite,
      status: :todo,
      estimated_minutes: 30
    )

    new_task.save!

    assert_enqueued_with(job: Caching::BreakTasksAndOnsitesCacheForOrganizationJob, args: [job: job])
    assert_no_enqueued_jobs(only: Caching::BreakTaskCacheForOrganizationOnsiteJob)
  end

  test "queues up cache breaks when creating a record (onsite)" do
    perform_enqueued_jobs

    job = organization_jobs.repeat_customer
    onsite = job.onsites.first
    new_task = job.tasks.build(
      label: Faker::Hacker.say_something_smart,
      original_creator: users.organization_1_owner,
      onsite: onsite,
      task_type: :onsite,
      status: :todo,
      estimated_minutes: 30
    )

    new_task.save!

    assert_enqueued_with(job: Caching::BreakTasksAndOnsitesCacheForOrganizationJob, args: [job: job])
    assert_enqueued_with(job: Caching::BreakTaskCacheForOrganizationOnsiteJob, args: [onsite: onsite])
  end

  test "queues up cache breaks when updating a record" do
    perform_enqueued_jobs

    job_task = organization_job_tasks.todo_repeat_onsite_1
    onsite = job_task.onsite
    job = job_task.job


    job_task.update!(
      label: Faker::Hacker.say_something_smart
    )

    assert_enqueued_with(job: Caching::BreakTasksAndOnsitesCacheForOrganizationJob, args: [job: job])
    assert_enqueued_with(job: Caching::BreakTaskCacheForOrganizationOnsiteJob, args: [onsite: onsite])
  end

  test "queues up cache breaks for the new & old onsites (moving)" do
    perform_enqueued_jobs

    job_task = organization_job_tasks.todo_repeat_onsite_1
    old_onsite = job_task.onsite
    job = job_task.job

    new_onsite = job.onsites.last

    assert_not_equal old_onsite, new_onsite

    job_task.update!(
      onsite: new_onsite
    )

    assert_enqueued_with(job: Caching::BreakTasksAndOnsitesCacheForOrganizationJob, args: [job: job])
    assert_enqueued_with(job: Caching::BreakTaskCacheForOrganizationOnsiteJob, args: [onsite: old_onsite])
    assert_enqueued_with(job: Caching::BreakTaskCacheForOrganizationOnsiteJob, args: [onsite: new_onsite])
  end

  test "queues up cache breaks for the new & old onsites and jobs (moving)" do
    perform_enqueued_jobs

    job_task = organization_job_tasks.todo_repeat_onsite_1
    old_onsite = job_task.onsite
    old_job = job_task.job

    new_job = organization_jobs.maintenance_agreement_job_1
    new_onsite = organization_onsites.maintenance_agreement_onsite_1

    job_task.update!(
      onsite: new_onsite,
      job: new_job
    )

    assert_enqueued_with(job: Caching::BreakTasksAndOnsitesCacheForOrganizationJob, args: [job: old_job])
    assert_enqueued_with(job: Caching::BreakTasksAndOnsitesCacheForOrganizationJob, args: [job: new_job])
    assert_enqueued_with(job: Caching::BreakTaskCacheForOrganizationOnsiteJob, args: [onsite: old_onsite])
    assert_enqueued_with(job: Caching::BreakTaskCacheForOrganizationOnsiteJob, args: [onsite: new_onsite])
  end

  test "queues up cache breaks for the old onsite (removing an onsite)" do
    perform_enqueued_jobs

    job_task = organization_job_tasks.todo_repeat_onsite_1
    onsite = job_task.onsite
    job = job_task.job

    assert_not_nil onsite

    job_task.update!(
      onsite: nil
    )

    assert_enqueued_with(job: Caching::BreakTasksAndOnsitesCacheForOrganizationJob, args: [job: job])
    assert_enqueued_with(job: Caching::BreakTaskCacheForOrganizationOnsiteJob, args: [onsite: onsite])
  end

  test "queues up cache breaks for the new onsite (adding an onsite)" do
    perform_enqueued_jobs

    job_task = organization_job_tasks.maintenance_agreement_offsite_task_4
    new_onsite = organization_onsites.maintenance_agreement_onsite_4
    job = job_task.job

    assert_nil job_task.onsite

    job_task.update!(
      onsite: new_onsite
    )

    assert_enqueued_with(job: Caching::BreakTasksAndOnsitesCacheForOrganizationJob, args: [job: job])
    assert_enqueued_with(job: Caching::BreakTaskCacheForOrganizationOnsiteJob, args: [onsite: new_onsite])
  end

  test "queues up cache breaks for the onsite when deleting a task" do
    perform_enqueued_jobs

    job_task = organization_job_tasks.todo_repeat_onsite_1
    onsite = job_task.onsite
    job = job_task.job

    job_task.destroy

    assert_enqueued_with(job: Caching::BreakTasksAndOnsitesCacheForOrganizationJob, args: [job: job])
    assert_enqueued_with(job: Caching::BreakTaskCacheForOrganizationOnsiteJob, args: [onsite: onsite])
  end
end