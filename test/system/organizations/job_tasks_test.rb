# frozen_string_literal: true

require "application_system_test_case"

class Organization::JobTaskSystemTest < ApplicationSystemTestCase
  test "creates a new job task for a job" do
    user = users.organization_1_department_head
    organization = organizations.organization_1
    assert_sign_in_user(user: user)

    job = organization_jobs.repeat_customer

    visit organization_job_url(organization, job)

    task_label = Faker::Team.name

    within(".add-task-form") do
      fill_in "Task", with: task_label
      choose "Offsite"
      click_on I18n.t("dispatcher.onsites.form.submit_button_title")
    end

    assert_current_path organization_job_url(organization, job)

    assert_toast_message(text: I18n.translate("dispatcher.job_tasks.created_message"))

    new_task = job.tasks.find_by(label: task_label)

    if WebAwesomeTest.web_awesome?
      assert_link task_label, href: edit_job_task_url(organization, new_task)
    else
      assert_link task_label, href: job_task_url(organization, new_task)
    end
  end

  test "updates a job_task" do
    user = users.organization_1_department_head
    organization = organizations.organization_1
    assert_sign_in_user(user: user)

    job_task = organization_job_tasks.todo_repeat_onsite_1
    onsite = job_task.onsite

    visit job_task_url(organization, job_task)

    click_link I18n.t("dispatcher.job_tasks.edit_job_task.link_title")

    task_label = Faker::Team.name

    fill_in "Task", with: task_label
    choose "Onsite"
    fill_in "Estimated Duration", with: "30"
    click_on I18n.t("dispatcher.onsites.form.submit_button_title")

    assert_current_path onsite_url(organization, onsite)

    assert_toast_message(text: I18n.translate("dispatcher.job_tasks.updated_message", job_task_label: task_label))
  end
end