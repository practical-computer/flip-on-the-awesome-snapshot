# frozen_string_literal: true

require "application_system_test_case"

class Organization::NoteSystemTest < ApplicationSystemTestCase
  include PracticalFramework::TestHelpers::TiptapDocumentHelpers
  include ActionView::RecordIdentifier

  test "can see all the notes on the index" do
    user = users.organization_1_department_head
    organization = organizations.organization_1
    assert_sign_in_user(user: user)

    job = organization_jobs.repeat_customer
    job_note = Faker::Quotes::Shakespeare.hamlet_quote
    job_note_record = job.create_note!(
      tiptap_document: example_tiptap_document(sentence: job_note),
      original_author: user,
      organization: organization
    )

    onsite = organization_onsites.repeat_onsite_2
    onsite_note = Faker::Quotes::Shakespeare.hamlet_quote
    onsite_note_record = onsite.notes.create!(
      tiptap_document: example_tiptap_document(sentence: onsite_note),
      original_author: user,
      organization: organization
    )

    visit organization_notes_url(organization)

    if WebAwesomeTest.web_awesome?
      assert_selector "h2", text: I18n.t("dispatcher.notes.title")
    else
      assert_selector "h1", text: I18n.t("dispatcher.notes.title")
    end

    within("[role='list']") do
      find_by_id(dom_id(job_note_record)) do
        assert_selector ".tiptap-document", text: job_note
      end

      find_by_id(dom_id(onsite_note_record)) do
        assert_selector ".tiptap-document", text: onsite_note
      end
    end
  end
end

class Organization::NoteSystemEditorTest < SlowBrowserSystemTestCase
  include PracticalFramework::TestHelpers::TiptapDocumentHelpers
  include ActionView::RecordIdentifier

  test "requires confirmation before deleting a note" do
    user = users.organization_1_department_head
    organization = organizations.organization_1
    assert_sign_in_user(user: user)

    onsite = organization_onsites.repeat_onsite_2
    onsite_note = Faker::Quotes::Shakespeare.hamlet_quote
    onsite_note_record = onsite.notes.create!(
      tiptap_document: example_tiptap_document(sentence: onsite_note),
      original_author: user,
      organization: organization
    )

    visit onsite_url(organization, onsite)

    dismiss_confirm(I18n.t("dispatcher.notes.delete_note.confirmation_message")) do
      find_by_id(dom_id(onsite_note_record)) do
        click_button I18n.t("dispatcher.notes.delete_note.link_title")
      end
    end

    page.refresh

    assert_not_nil Organization::Note.find_by(id: onsite_note_record.id)

    accept_confirm(I18n.t("dispatcher.notes.delete_note.confirmation_message")) do
      find_by_id(dom_id(onsite_note_record)) do
        click_button I18n.t("dispatcher.notes.delete_note.link_title")
      end
    end

    assert_current_path onsite_url(organization, onsite)
    assert_no_element("##{dom_id(onsite_note_record)}")
    assert_nil Organization::Note.find_by(id: onsite_note_record.id)
  end

  test "creates a new note for an onsite and redirects back to the onsite" do
    user = users.organization_1_department_head
    organization = organizations.organization_1
    assert_sign_in_user(user: user)

    onsite = organization_onsites.repeat_onsite_2
    onsite_note = Faker::Quotes::Shakespeare.hamlet_quote

    visit onsite_url(organization, onsite)

    if WebAwesomeTest.web_awesome?
      type_into_editor(container_element: find(".add-note-form"), keys: onsite_note)

      within('.add-note-form') do
        click_on I18n.t("dispatcher.notes.form.submit_button_title")
      end
    else
      within('.add-note-form') do
        type_into_editor(container_element: find("fieldset", text: "Notes"), keys: onsite_note)
        click_on I18n.t("dispatcher.notes.form.submit_button_title")
      end
    end

    new_note = onsite.notes.last

    assert_toast_message(text: I18n.translate("dispatcher.notes.created_message"))

    assert_current_path onsite_url(organization, onsite)

    find_by_id(dom_id(new_note)) do
      assert_selector '.tiptap-document', text: onsite_note
    end
  end

  test "updates a note for an onsite and redirects back to the onsite" do
    user = users.organization_1_department_head
    organization = organizations.organization_1
    assert_sign_in_user(user: user)

    onsite = organization_onsites.repeat_onsite_2
    old_note = Faker::Quotes::Shakespeare.hamlet_quote
    onsite_note_record = onsite.notes.create!(
      tiptap_document: example_tiptap_document(sentence: old_note),
      original_author: user,
      organization: organization
    )

    new_onsite_note = Faker::Quotes::Shakespeare.hamlet_quote

    visit onsite_url(organization, onsite)

    find_by_id(dom_id(onsite_note_record)) do
      click_link I18n.t("dispatcher.notes.edit_note.link_title")
    end

    assert_current_path edit_organization_note_url(organization, onsite_note_record)

    if WebAwesomeTest.web_awesome?
      type_into_editor(container_element: find(".note-form", text: "Notes"), keys: new_onsite_note)
    else
      type_into_editor(container_element: find("fieldset", text: "Notes"), keys: new_onsite_note)
    end
    click_on I18n.t("dispatcher.notes.form.submit_button_title")

    assert_toast_message(text: I18n.translate("dispatcher.notes.updated_message"))

    assert_current_path onsite_url(organization, onsite)

    find_by_id(dom_id(onsite_note_record)) do
      assert_selector '.tiptap-document', text: new_onsite_note
    end
  end

  test "updates a note for a job and redirects back to the job" do
    user = users.organization_1_department_head
    organization = organizations.organization_1
    assert_sign_in_user(user: user)

    job = organization_jobs.repeat_customer
    job_note = Faker::Quotes::Shakespeare.hamlet_quote
    job_note_record = job.create_note!(
      tiptap_document: example_tiptap_document(sentence: job_note),
      original_author: user,
      organization: organization
    )

    new_job_note = Faker::Quotes::Shakespeare.hamlet_quote

    visit organization_notes_url(organization)

    find_by_id(dom_id(job_note_record)) do
      click_link I18n.t("dispatcher.notes.edit_note.link_title")
    end

    assert_current_path edit_organization_note_url(organization, job_note_record)

    if WebAwesomeTest.web_awesome?
      type_into_editor(container_element: find(".note-form"), keys: new_job_note)
    else
      type_into_editor(container_element: find("fieldset", text: "Notes"), keys: new_job_note)
    end
    click_on I18n.t("dispatcher.notes.form.submit_button_title")

    assert_toast_message(text: I18n.translate("dispatcher.notes.updated_message"))

    assert_current_path organization_job_url(organization, job)

    assert_selector '.tiptap-document', text: new_job_note
  end
end