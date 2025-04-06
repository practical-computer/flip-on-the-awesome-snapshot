# frozen_string_literal: true

require "test_helper"

class Organizations::JobTasksControllerTest < ActionDispatch::IntegrationTest
  include PracticalFramework::TestHelpers::TiptapDocumentHelpers

  def assert_create_policies_applied(organization:, &block)
    assert_authorized_to(:show?, organization, with: OrganizationPolicy) do
      assert_authorized_to(:create?, nil, with: Organization::JobTaskPolicy, &block)
    end
  end

  def assert_job_manage_task_policies_applied(organization:, user:, target_job:, &block)
    assert_authorized_to(:show?, organization, with: OrganizationPolicy) do
      assert_authorized_to(:manage_tasks?, target_job, with: Organization::JobPolicy, &block)
    end
  end

  def assert_manage_policies_applied(organization:, job_task:, &block)
    assert_authorized_to(:show?, organization, with: OrganizationPolicy) do
      assert_authorized_to(:manage?, job_task, with: Organization::JobTaskPolicy, &block)
    end
  end

  test "new: renders the form for a new job_task (no onsite)" do
    user = users.moonlighter
    organization = organizations.organization_1
    organization_job = organization_jobs.repeat_customer
    sign_in(user)

    assert_job_manage_task_policies_applied(organization: organization, user: user, target_job: organization_job) do
      get new_organization_job_task_url(organization, organization_job)
    end

    assert_response :ok
  end

  test "new: renders the form for a new job_task (with an onsite)" do
    user = users.moonlighter
    organization = organizations.organization_1
    organization_job = organization_jobs.repeat_customer
    organization_onsite = organization_onsites.repeat_onsite_1
    sign_in(user)

    assert_job_manage_task_policies_applied(organization: organization, user: user, target_job: organization_job) do
      get new_organization_job_task_url(organization, organization_job, onsite_id: organization_onsite.id)
    end

    assert_response :ok
  end

  test "create: creates a new job_task without an onsite" do
    user = users.moonlighter
    organization = organizations.organization_1
    organization_job = organization_jobs.repeat_customer
    sign_in(user)

    label = Faker::Team.name
    estimated_duration = "1:20"

    params = {
      organization_job_task: {
        label: label,
        estimated_duration: estimated_duration,
        status: :todo
      }
    }

    assert_job_manage_task_policies_applied(organization: organization, user: user, target_job: organization_job) do
    assert_no_difference "Organization::Job.count" do
    assert_difference "Organization::JobTask.count", +1 do
      post organization_job_tasks_url(organization, organization_job), params: params, as: :json
    end
    end
    end

    new_task = organization.job_tasks.last

    message = I18n.t("dispatcher.job_tasks.created_message")
    assert_flash_message(type: :success, message: message, icon_name: "fa-clipboard-list-check")

    assert_equal organization, new_task.organization
    assert_equal organization_job, new_task.job
    assert_nil new_task.onsite
    assert_equal label, new_task.label
    assert_equal 80, new_task.estimated_minutes
    assert_equal true, new_task.onsite?
    assert_equal true, new_task.todo?
  end

  test "create: creates a new job_task with an onsite" do
    user = users.moonlighter
    organization = organizations.organization_1
    organization_job = organization_jobs.repeat_customer
    onsite = organization_onsites.repeat_onsite_2
    sign_in(user)

    label = Faker::Team.name
    estimated_duration = "1:20"

    params = {
      organization_job_task: {
        label: label,
        estimated_duration: estimated_duration,
        status: :todo,
        onsite: onsite.id
      }
    }

    assert_job_manage_task_policies_applied(organization: organization, user: user, target_job: organization_job) do
    assert_no_difference "Organization::Job.count" do
    assert_difference "Organization::JobTask.count", +1 do
      post organization_job_tasks_url(organization, organization_job), params: params, as: :json
    end
    end
    end

    new_task = organization.job_tasks.last

    message = I18n.t("dispatcher.job_tasks.created_message")
    assert_flash_message(type: :success, message: message, icon_name: "fa-clipboard-list-check")

    assert_equal organization, new_task.organization
    assert_equal organization_job, new_task.job
    assert_equal onsite, new_task.onsite
    assert_equal label, new_task.label
    assert_equal 80, new_task.estimated_minutes
    assert_equal true, new_task.onsite?
    assert_equal true, new_task.todo?
  end

  test "create: renders errors as JSON" do
    user = users.moonlighter
    organization = organizations.organization_1
    organization_job = organization_jobs.repeat_customer
    sign_in(user)

    label = " "
    estimated_duration = "x"

    params = {
      organization_job_task: {
        label: label,
        estimated_duration: estimated_duration,
        status: :todo
      }
    }

    assert_job_manage_task_policies_applied(organization: organization, user: user, target_job: organization_job) do
    assert_no_difference "Organization::Job.count" do
    assert_no_difference "Organization::JobTask.count" do
      post organization_job_tasks_url(organization, organization_job), params: params, as: :json
    end
    end
    end

    assert_response :bad_request

    assert_error_json_contains(
      container_id: "organization_job_task_label_errors",
      element_id: "organization_job_task_label",
      message: "can't be blank",
    )
  end

  test "create: renders errors as HTML" do
    user = users.moonlighter
    organization = organizations.organization_1
    organization_job = organization_jobs.repeat_customer
    sign_in(user)

    label = " "
    estimated_duration = "x"

    params = {
      organization_job_task: {
        label: label,
        estimated_duration: estimated_duration,
        status: :todo
      }
    }

    assert_job_manage_task_policies_applied(organization: organization, user: user, target_job: organization_job) do
    assert_no_difference "Organization::Job.count" do
    assert_no_difference "Organization::JobTask.count" do
      post organization_job_tasks_url(organization, organization_job), params: params
    end
    end
    end

    assert_response :bad_request

    assert_error_dom(
      container_id: "organization_job_task_label_errors",
      message: "can't be blank",
    )
  end

  test "show: renders an existing job_task (no onsite)" do
    skip "Not shown for Web Awesome" if WebAwesomeTest.web_awesome?
    user = users.moonlighter
    organization = organizations.organization_1
    organization_job = organization_jobs.repeat_customer
    sign_in(user)

    job_task = organization_job_tasks.todo_offsite_repeat_job

    assert_manage_policies_applied(organization: organization, job_task: job_task) do
      get job_task_url(organization, job_task)
    end

    assert_response :ok
    assert_dom "h1", text: job_task.label

    assert_dom "dd em", text: I18n.t("dispatcher.job_tasks.no_onsite.human")
    assert_dom "header nav li", text: %r{#{organization_job.name}}
  end

  test "show: renders an existing job_task (onsite)" do
    skip "Not shown for Web Awesome" if WebAwesomeTest.web_awesome?
    user = users.moonlighter
    organization = organizations.organization_1
    organization_job = organization_jobs.repeat_customer
    sign_in(user)

    job_task = organization_job_tasks.todo_repeat_onsite_1
    onsite = job_task.onsite

    assert_manage_policies_applied(organization: organization, job_task: job_task) do
      get job_task_url(organization, job_task)
    end

    assert_response :ok
    assert_dom "h1", text: job_task.label
    assert_dom "dd", text: onsite.label
    assert_dom "header nav li", text: %r{#{organization_job.name}}
    assert_dom "header nav li", text: %r{#{onsite.label}}
  end

  test "edit: renders the edit form for an existing job_task (no onsite)" do
    user = users.moonlighter
    organization = organizations.organization_1
    organization_job = organization_jobs.repeat_customer
    sign_in(user)

    job_task = organization_job_tasks.todo_offsite_repeat_job

    assert_manage_policies_applied(organization: organization, job_task: job_task) do
      get edit_job_task_url(organization, job_task)
    end

    assert_response :ok
    if WebAwesomeTest.web_awesome?
      assert_dom "section wa-breadcrumb-item", text: %r{#{organization_job.name}}
    else
      assert_dom "header nav li", text: %r{#{organization_job.name}}
    end
  end

  test "edit: renders the edit form for an existing job_task (onsite)" do
    user = users.moonlighter
    organization = organizations.organization_1
    organization_job = organization_jobs.repeat_customer
    sign_in(user)

    job_task = organization_job_tasks.todo_repeat_onsite_1
    onsite = job_task.onsite

    assert_manage_policies_applied(organization: organization, job_task: job_task) do
      get edit_job_task_url(organization, job_task)
    end

    assert_response :ok
    if WebAwesomeTest.web_awesome?
      assert_dom "section wa-breadcrumb-item", text: %r{#{organization_job.name}}
      assert_dom "section wa-breadcrumb-item", text: %r{#{onsite.label}}
    else
      assert_dom "header nav li", text: %r{#{organization_job.name}}
      assert_dom "header nav li", text: %r{#{onsite.label}}
    end
  end

  test "update: updates the existing job_task" do
    user = users.moonlighter
    organization = organizations.organization_1
    organization_job = organization_jobs.repeat_customer
    sign_in(user)

    job_task = organization_job_tasks.todo_offsite_repeat_job

    new_label = Faker::Team.name
    estimated_duration = "1:20"

    params = {
      organization_job_task: {
        label: new_label,
        estimated_duration: estimated_duration,
        status: :done,
        task_type: :onsite,
      }
    }

    assert_manage_policies_applied(organization: organization, job_task: job_task) do
    assert_no_difference "Organization::JobTask.count" do
      patch job_task_url(organization, job_task), params: params, as: :json
    end
    end

    job_task.reload

    assert_json_redirected_to(organization_job_url(organization, organization_job))

    message = I18n.t('dispatcher.job_tasks.updated_message', job_task_label: new_label)
    assert_flash_message(type: :success, message: message, icon_name: "fa-clipboard-list-check")

    assert_equal new_label, job_task.label
    assert_equal 80, job_task.estimated_minutes
    assert_equal true, job_task.done?
    assert_equal true, job_task.onsite?
  end

  test "update: renders errors as JSON" do
    user = users.moonlighter
    organization = organizations.organization_1
    organization_job = organization_jobs.repeat_customer
    sign_in(user)

    job_task = organization_job_tasks.todo_offsite_repeat_job

    new_label = Faker::Team.name
    estimated_duration = "1:20"

    params = {
      organization_job_task: {
        label: "  ",
      }
    }

    assert_manage_policies_applied(organization: organization, job_task: job_task) do
    assert_no_difference "Organization::JobTask.count" do
      patch job_task_url(organization, job_task), params: params, as: :json
    end
    end

    assert_response :bad_request

    assert_error_json_contains(
      container_id: "organization_job_task_label_errors",
      element_id: "organization_job_task_label",
      message: "can't be blank",
    )
  end

  test "update: renders errors as HTML" do
    user = users.moonlighter
    organization = organizations.organization_1
    organization_job = organization_jobs.repeat_customer
    sign_in(user)

    job_task = organization_job_tasks.todo_offsite_repeat_job

    new_label = Faker::Team.name
    estimated_duration = "1:20"

    params = {
      organization_job_task: {
        label: "  ",
      }
    }

    assert_manage_policies_applied(organization: organization, job_task: job_task) do
    assert_no_difference "Organization::JobTask.count" do
      patch job_task_url(organization, job_task), params: params
    end
    end

    assert_response :bad_request

    assert_error_dom(
      container_id: "organization_job_task_label_errors",
      message: "can't be blank",
    )
  end

  test "update: updates the existing job_task to assign it to a new onsite" do
    user = users.moonlighter
    organization = organizations.organization_1
    organization_job = organization_jobs.repeat_customer
    sign_in(user)

    job_task = organization_job_tasks.todo_repeat_onsite_1

    new_onsite = organization_onsites.repeat_onsite_2

    assert_not_equal new_onsite, job_task.onsite

    params = {
      organization_job_task: {
        onsite: new_onsite.id
      }
    }

    assert_manage_policies_applied(organization: organization, job_task: job_task) do
    assert_no_difference "Organization::JobTask.count" do
      patch job_task_url(organization, job_task), params: params, as: :json
    end
    end

    job_task.reload

    assert_json_redirected_to(onsite_url(organization, new_onsite))

    message = I18n.t('dispatcher.job_tasks.updated_message', job_task_label: job_task.label)
    assert_flash_message(type: :success, message: message, icon_name: "fa-clipboard-list-check")

    assert_equal new_onsite, job_task.onsite
  end

  test "update: updates the existing job_task to unassign it from an onsite" do
    user = users.moonlighter
    organization = organizations.organization_1
    organization_job = organization_jobs.repeat_customer
    sign_in(user)

    job_task = organization_job_tasks.todo_repeat_onsite_1

    assert_not_nil job_task.onsite

    params = {
      organization_job_task: {
        onsite: nil
      }
    }

    assert_manage_policies_applied(organization: organization, job_task: job_task) do
    assert_no_difference "Organization::JobTask.count" do
      patch job_task_url(organization, job_task), params: params, as: :json
    end
    end

    job_task.reload

    assert_json_redirected_to(organization_job_url(organization, organization_job))

    message = I18n.t('dispatcher.job_tasks.updated_message', job_task_label: job_task.label)
    assert_flash_message(type: :success, message: message, icon_name: "fa-clipboard-list-check")

    assert_nil job_task.onsite
  end

  test "update: updates the existing job_task to change the status without changing the onsite" do
    user = users.moonlighter
    organization = organizations.organization_1
    organization_job = organization_jobs.repeat_customer
    sign_in(user)

    job_task = organization_job_tasks.todo_repeat_onsite_1
    organization_onsite = job_task.onsite

    assert_not_nil organization_onsite

    params = {
      organization_job_task: {
        status: :cancelled
      }
    }

    assert_manage_policies_applied(organization: organization, job_task: job_task) do
    assert_no_difference "Organization::JobTask.count" do
      patch job_task_url(organization, job_task), params: params, as: :json
    end
    end

    job_task.reload
    assert_equal organization_onsite, job_task.onsite

    assert_json_redirected_to(onsite_url(organization, organization_onsite))

    message = I18n.t('dispatcher.job_tasks.updated_message', job_task_label: job_task.label)
    assert_flash_message(type: :success, message: message, icon_name: "fa-clipboard-list-check")
  end
end