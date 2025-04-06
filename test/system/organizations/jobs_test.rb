# frozen_string_literal: true

require "application_system_test_case"

class Organizations::JobsTest < ApplicationSystemTestCase
  test "Can see all the jobs on the index" do
    user = users.organization_1_department_head
    organization = organizations.organization_1
    assert_sign_in_user(user: user)

    visit organization_jobs_url(organization)
    if WebAwesomeTest.web_awesome?
      assert_selector "h2", text: I18n.t("dispatcher.jobs.title")
    else
      assert_selector "h1", text: I18n.t("dispatcher.jobs.title")
    end

    organization.jobs.each do |job|
      within("table.jobs") do
        has_link? job.name, href: organization_job_url(organization, job)
      end
    end
  end

  test "should create a new job" do
    user = users.organization_1_department_head
    organization = organizations.organization_1
    assert_sign_in_user(user: user)

    visit organization_jobs_url(organization)

    click_link I18n.t("dispatcher.jobs.new_job.link_title")

    assert_current_path new_organization_job_url(organization)

    job_name = Faker::Company.name

    fill_in "Name", with: job_name

    click_on I18n.t("dispatcher.jobs.form.submit_button_title")

    new_job = organization.jobs.find_by(name: job_name)

    assert_current_path organization_job_url(organization, new_job)

    assert_toast_message(text: I18n.translate("dispatcher.jobs.created_message"))

    if WebAwesomeTest.web_awesome?
      assert_selector "h2", text: new_job.name
    else
      assert_selector "h1", text: new_job.name
    end
  end

  test "should update Job" do
    user = users.organization_1_department_head
    organization = organizations.organization_1
    assert_sign_in_user(user: user)

    job = organization_jobs.repeat_customer

    visit organization_jobs_url(organization)

    click_link job.name

    assert_current_path organization_job_url(organization, job)

    click_link I18n.t("dispatcher.jobs.edit_job.link_title"), href: edit_organization_job_url(organization, job)

    new_job_name = Faker::Company.name

    fill_in "Name", with: new_job_name

    click_on I18n.t("dispatcher.jobs.form.submit_button_title")

    job.reload

    assert_current_path organization_job_url(organization, job)

    assert_toast_message(text: I18n.translate("dispatcher.jobs.updated_message", job_name: new_job_name))

    if WebAwesomeTest.web_awesome?
      assert_selector "h2", text: job.name
    else
      assert_selector "h1", text: job.name
    end
  end
end


class Organizations::JobsNotesTest < SlowBrowserSystemTestCase
  include PracticalFramework::TestHelpers::TiptapDocumentHelpers

  test "notes field works when creating job" do
    user = users.organization_1_department_head
    organization = organizations.organization_1
    assert_sign_in_user(user: user)

    visit organization_jobs_url(organization)

    click_link I18n.t("dispatcher.jobs.new_job.link_title")

    assert_current_path new_organization_job_url(organization)

    job_name = Faker::Company.name
    note = Faker::Quotes::Shakespeare.hamlet_quote

    fill_in "Name", with: job_name
    type_into_editor(container_element: find("fieldset", text: "Notes"), keys: note)

    click_on I18n.t("dispatcher.jobs.form.submit_button_title")

    assert_toast_message(text: I18n.translate("dispatcher.jobs.created_message"))

    new_job = organization.jobs.find_by(name: job_name)

    assert_current_path organization_job_url(organization, new_job)

    if WebAwesomeTest.web_awesome?
      assert_selector "h2", text: new_job.name
    else
      assert_selector "h1", text: new_job.name
    end

    assert_selector ".tiptap-document p", text: note
  end

  test "notes field works when updating job without an existing note" do
    user = users.organization_1_department_head
    organization = organizations.organization_1
    assert_sign_in_user(user: user)

    job = organization_jobs.repeat_customer

    visit organization_jobs_url(organization)

    click_link job.name

    assert_current_path organization_job_url(organization, job)

    click_link I18n.t("dispatcher.jobs.edit_job.link_title"), href: edit_organization_job_url(organization, job)

    new_job_name = Faker::Company.name
    note = Faker::Quotes::Shakespeare.hamlet_quote

    fill_in "Name", with: new_job_name
    type_into_editor(container_element: find("fieldset", text: "Notes"), keys: note)

    click_on I18n.t("dispatcher.jobs.form.submit_button_title")

    assert_toast_message(text: I18n.translate("dispatcher.jobs.updated_message", job_name: new_job_name))

    job.reload

    assert_current_path organization_job_url(organization, job)

    if WebAwesomeTest.web_awesome?
      assert_selector "h2", text: job.name
    else
      assert_selector "h1", text: job.name
    end

    assert_selector ".tiptap-document p", text: note
  end

  test "notes field works when updating job with an existing note" do
    user = users.organization_1_department_head
    organization = organizations.organization_1
    assert_sign_in_user(user: user)

    existing_sentence = Faker::Quotes::Shakespeare.king_richard_iii
    existing_note = example_tiptap_document(sentence: existing_sentence)

    job = organization_jobs.repeat_customer
    job.create_note!(tiptap_document: existing_note, organization: organization, original_author: user)

    visit organization_jobs_url(organization)

    click_link job.name

    assert_current_path organization_job_url(organization, job)

    click_link I18n.t("dispatcher.jobs.edit_job.link_title"), href: edit_organization_job_url(organization, job)

    new_job_name = Faker::Company.name
    note = Faker::Quotes::Shakespeare.hamlet_quote

    fill_in "Name", with: new_job_name
    type_into_editor(container_element: find("fieldset", text: "Notes"), keys: [:enter, :up, note])

    click_on I18n.t("dispatcher.jobs.form.submit_button_title")

    assert_toast_message(text: I18n.translate("dispatcher.jobs.updated_message", job_name: new_job_name))

    job.reload

    assert_current_path organization_job_url(organization, job)

    if WebAwesomeTest.web_awesome?
      assert_selector "h2", text: job.name
    else
      assert_selector "h1", text: job.name
    end

    assert_selector ".tiptap-document", text: note
    assert_selector ".tiptap-document", text: existing_sentence
  end
end