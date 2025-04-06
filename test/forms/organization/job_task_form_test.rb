# frozen_string_literal: true

require "test_helper"

class Organization::JobTaskFormTest < ActiveSupport::TestCase
  test "initialize a new form with todo & onsite as the status & task_type, 1:00 estimated_duration" do
    organization = organizations.organization_1
    user = users.moonlighter
    onsite = organization_onsites.repeat_onsite_1
    job = onsite.job

    form = Organization::JobTaskForm.new(
      current_organization: organization,
      current_user: user,
      job: job,
      onsite: onsite,
    )

    assert_equal "todo", form.status
    assert_equal "onsite", form.task_type
    assert_equal "1:00", form.estimated_duration
  end

  test "can create a new job_task for an onsite" do
    organization = organizations.organization_1
    user = users.moonlighter
    onsite = organization_onsites.repeat_onsite_1
    job = onsite.job
    label = Faker::Team.name
    task_type = :onsite
    status = :todo

    form = Organization::JobTaskForm.new(
      current_organization: organization,
      current_user: user,
      job: job,
      onsite: onsite,
      label: label,
      task_type: task_type,
      status: status,
    )

    assert_difference "Organization::JobTask.count", +1 do
      form.save!
    end

    job_task = form.job_task

    assert_equal job, job_task.job
    assert_equal onsite, job_task.onsite
    assert_equal label, job_task.label
    assert_equal task_type.to_s, job_task.task_type
    assert_equal status.to_s, job_task.status
  end

  test "can create a new job_task that's not assigned to an onsite" do
    organization = organizations.organization_1
    user = users.moonlighter
    job = organization_jobs.repeat_customer
    label = Faker::Team.name
    task_type = :onsite
    status = :todo

    form = Organization::JobTaskForm.new(
      current_organization: organization,
      current_user: user,
      job: job,
      label: label,
      task_type: task_type,
      status: status,
    )

    assert_difference "Organization::JobTask.count", +1 do
      form.save!
    end

    job_task = form.job_task

    assert_equal job, job_task.job
    assert_nil job_task.onsite
    assert_equal label, job_task.label
    assert_equal task_type.to_s, job_task.task_type
    assert_equal status.to_s, job_task.status
  end

  test "can update an existing job_task" do
    organization = organizations.organization_1
    user = users.moonlighter
    existing_job_task = organization_job_tasks.todo_repeat_onsite_1

    existing_onsite = existing_job_task.onsite
    label = Faker::Team.name
    task_type = :offsite
    status = :cancelled

    form = Organization::JobTaskForm.new(
      current_organization: organization,
      current_user: user,
      job_task: existing_job_task,
      label: label,
      task_type: task_type,
      status: status,
    )

    assert_no_difference "Organization::JobTask.count" do
      form.save!
    end

    existing_job_task.reload
    assert_equal existing_onsite, existing_job_task.onsite
    assert_equal label, existing_job_task.label
    assert_equal task_type.to_s, existing_job_task.task_type
    assert_equal status.to_s, existing_job_task.status
  end

  test "can nullify an existing job_task estimated_duration" do
    organization = organizations.organization_1
    user = users.moonlighter
    existing_job_task = organization_job_tasks.todo_repeat_onsite_1

    assert_not_nil existing_job_task.estimated_minutes

    form = Organization::JobTaskForm.new(
      current_organization: organization,
      current_user: user,
      job_task: existing_job_task,
      estimated_duration: ""
    )

    assert_no_difference "Organization::JobTask.count" do
      form.save!
    end

    existing_job_task.reload
    assert_nil existing_job_task.estimated_minutes
  end

  test "can update an existing job_task to remove the onsite" do
    organization = organizations.organization_1
    user = users.moonlighter
    existing_job_task = organization_job_tasks.todo_repeat_onsite_1

    existing_onsite = existing_job_task.onsite

    form = Organization::JobTaskForm.new(
      current_organization: organization,
      current_user: user,
      job_task: existing_job_task,
      onsite: nil,
    )

    assert_no_difference "Organization::JobTask.count" do
      form.save!
    end

    existing_job_task.reload
    assert_nil existing_job_task.onsite
  end

  test "can update an existing job_task to add the onsite" do
    organization = organizations.organization_1
    user = users.moonlighter
    existing_job_task = organization_job_tasks.todo_offsite_repeat_job

    existing_onsite = organization_onsites.repeat_onsite_2

    form = Organization::JobTaskForm.new(
      current_organization: organization,
      current_user: user,
      job_task: existing_job_task,
      onsite: existing_onsite,
    )

    assert_no_difference "Organization::JobTask.count" do
      form.save!
    end

    existing_job_task.reload
    assert_equal existing_onsite, existing_job_task.onsite
  end

  test "does not change the job_task's original_creator" do
    organization = organizations.organization_1
    user = users.moonlighter
    existing_job_task = organization_job_tasks.todo_offsite_repeat_job

    original_creator = existing_job_task.original_creator
    assert_not_equal user, original_creator

    label = Faker::Team.name

    form = Organization::JobTaskForm.new(
      current_organization: organization,
      current_user: user,
      job_task: existing_job_task,
      label: label,
    )

    assert_no_difference "Organization::JobTask.count" do
      form.save!
    end

    existing_job_task.reload
    assert_equal original_creator, existing_job_task.original_creator
  end

  test "does not change the job_task's job" do
    organization = organizations.organization_1
    user = users.moonlighter
    existing_job_task = organization_job_tasks.todo_offsite_repeat_job

    old_job = existing_job_task.job

    job = organization_jobs.other_job
    assert_not_equal job, old_job

    label = Faker::Team.name

    form = Organization::JobTaskForm.new(
      current_organization: organization,
      current_user: user,
      job_task: existing_job_task,
      job: job,
    )

    assert_no_difference "Organization::JobTask.count" do
      form.save!
    end

    existing_job_task.reload
    assert_equal old_job, existing_job_task.job
  end

  test "raises a validation error if label is missing" do
    organization = organizations.organization_1
    user = users.moonlighter
    onsite = organization_onsites.repeat_onsite_1
    job = onsite.job
    task_type = :onsite
    status = :todo

    form = Organization::JobTaskForm.new(
      current_organization: organization,
      current_user: user,
      job: job,
      onsite: onsite,
      label: "",
      task_type: task_type,
      status: status,
    )

    assert_raises ActiveRecord::RecordInvalid do
      form.save!
    end

    assert_equal true, form.errors.of_kind?(:label, :blank)
  end

  test "raises a ActionPolicy::AuthorizationContextMissing error if the current_user is missing" do
    organization = organizations.organization_1
    onsite = organization_onsites.repeat_onsite_1
    job = onsite.job
    task_type = :onsite
    status = :todo

    form = Organization::JobTaskForm.new(
      current_organization: organization,
      job: job,
      label: "",
      task_type: task_type,
      status: status,
    )

    assert_raises ActionPolicy::AuthorizationContextMissing do
      form.save!
    end
  end

  test "raises a ActionPolicy::AuthorizationContextMissing error if the current_organization is missing" do
    user = users.moonlighter
    onsite = organization_onsites.repeat_onsite_1
    job = onsite.job
    task_type = :onsite
    status = :todo

    form = Organization::JobTaskForm.new(
      current_user: user,
      job: job,
      label: "",
      task_type: task_type,
      status: status,
    )

    assert_raises ActionPolicy::AuthorizationContextMissing do
      form.save!
    end
  end

  test "raises a validation error if the current_user cannot manage the new job_task" do
    organization = organizations.organization_1
    user = users.organization_3_owner
    onsite = organization_onsites.repeat_onsite_1
    job = onsite.job
    label = Faker::Team.name
    task_type = :onsite
    status = :todo

    form = Organization::JobTaskForm.new(
      current_organization: organization,
      current_user: user,
      job: job,
      onsite: onsite,
      label: label,
      task_type: task_type,
      status: status,
    )

    assert_raises ActiveModel::ValidationError do
      form.save!
    end

    assert_equal true, form.errors.of_kind?(:base, :cannot_manage_job_tasks)
  end

  test "raises a validation error if the current_user cannot manage the existing job_task" do
    organization = organizations.organization_1
    user = users.organization_3_owner
    existing_job_task = organization_job_tasks.todo_offsite_repeat_job
    label = Faker::Team.name

    form = Organization::JobTaskForm.new(
      current_organization: organization,
      current_user: user,
      job_task: existing_job_task,
      label: label,
    )

    assert_raises ActiveModel::ValidationError do
      form.save!
    end

    assert_equal true, form.errors.of_kind?(:base, :cannot_manage_job_tasks)
  end

  test "delegates persisted? and model_name to the underlying job_task" do
    organization = organizations.organization_1
    user = users.moonlighter
    onsite = organization_onsites.repeat_onsite_1
    job = onsite.job
    label = Faker::Team.name

    form = Organization::JobTaskForm.new(
      current_organization: organization,
      current_user: user,
      job: job,
      onsite: onsite,
      label: label,
    )

    assert_equal false, form.job_task.persisted?
    assert_equal false, form.persisted?

    assert_equal form.job_task.model_name, form.model_name

    form.save!

    assert_equal true, form.job_task.persisted?
    assert_equal true, form.persisted?

    assert_equal form.job_task.model_name, form.model_name
  end

  test "available_onsites: uses the available_to_assign_tasks_to scope for the job's onsites" do
    organization = organizations.organization_1
    user = users.moonlighter
    onsite = organization_onsites.repeat_onsite_1
    job = onsite.job
    label = Faker::Team.name

    form = Organization::JobTaskForm.new(
      current_organization: organization,
      current_user: user,
      job: job,
      onsite: onsite,
      label: label,
    )

    assert_equal job.onsites.available_to_assign_tasks_to, form.available_onsites
  end
end