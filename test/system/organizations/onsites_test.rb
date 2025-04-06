# frozen_string_literal: true

require "application_system_test_case"

class Organization::OnsitesTest < ApplicationSystemTestCase
  test "should create a new onsite" do
    user = users.organization_1_department_head
    organization = organizations.organization_1
    assert_sign_in_user(user: user)

    job = organization_jobs.repeat_customer

    visit organization_job_url(organization, job)

    click_link I18n.t("dispatcher.onsites.new_onsite.link_title")

    assert_current_path new_organization_job_onsite_url(organization, job)

    onsite_label = Faker::Team.name

    fill_in "Label", with: onsite_label

    click_on I18n.t("dispatcher.onsites.form.submit_button_title")

    new_onsite = organization.onsites.find_by(label: onsite_label)

    assert_current_path onsite_url(organization, new_onsite)

    assert_toast_message(text: I18n.translate("dispatcher.onsites.created_message"))

    if WebAwesomeTest.web_awesome?
      assert_selector "h2", text: new_onsite.label
    else
      assert_selector "h1", text: new_onsite.label
    end
  end

  test "should update an onsite" do
    user = users.organization_1_department_head
    organization = organizations.organization_1
    assert_sign_in_user(user: user)

    job = organization_jobs.repeat_customer
    onsite = organization_onsites.repeat_onsite_1

    visit organization_job_url(organization, job)

    within(".onsites") do
      click_link onsite.label
    end

    assert_current_path onsite_url(organization, onsite)

    click_link I18n.t("dispatcher.onsites.edit_onsite.link_title"), href: edit_onsite_url(organization, onsite)

    assert_current_path edit_onsite_url(organization, onsite)

    onsite_label = Faker::Team.name

    fill_in "Label", with: onsite_label

    click_on I18n.t("dispatcher.onsites.form.submit_button_title")

    onsite.reload

    assert_current_path onsite_url(organization, onsite)

    message = I18n.translate("dispatcher.onsites.updated_message", onsite_label: onsite.label,
                                                                    job_name: job.name
                             )

    assert_toast_message(text: message)

    if WebAwesomeTest.web_awesome?
      assert_selector "h2", text: onsite.label
    else
      assert_selector "h1", text: onsite.label
    end
  end
end
