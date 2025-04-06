# frozen_string_literal: true

require "test_helper"

class Organization::NoteFormTest < ActiveSupport::TestCase
  include PracticalFramework::TestHelpers::TiptapDocumentHelpers

  test "can create a new note" do
    organization = organizations.organization_1
    user = users.moonlighter
    resource = organization_onsites.repeat_onsite_1
    note_document = example_tiptap_document

    form = Organization::NoteForm.new(
      current_organization: organization,
      current_user: user,
      tiptap_document: note_document.to_json,
      resource: resource
    )

    assert_difference "Organization::Note.count", +1 do
      form.save!
    end

    note = form.note

    assert_equal organization, note.organization
    assert_equal user, note.original_author
    assert_equal note_document.as_json, note.tiptap_document.as_json
    assert_equal resource, note.resource
  end

  test "can update an existing note" do
    seed "cases/note_editing"

    note = organization_notes.organization_1_note
    organization = note.organization
    user = note.original_author

    old_resource = note.resource

    note_document = example_tiptap_document(sentence: Faker::TvShows::Community.quotes)

    form = Organization::NoteForm.new(
      current_organization: organization,
      current_user: user,
      tiptap_document: note_document.to_json,
      note: note
    )

    assert_no_difference "Organization::Note.count" do
      form.save!
    end

    note = form.note.reload

    assert_equal organization, note.organization
    assert_equal user, note.original_author
    assert_equal note_document.as_json, note.tiptap_document.as_json
    assert_equal old_resource, note.resource
  end

  test "does not change the note's original_creator" do
    seed "cases/note_editing"

    note = organization_notes.organization_1_note
    organization = note.organization
    user = users.moonlighter

    old_original_author = note.original_author
    old_resource = note.resource

    note_document = example_tiptap_document(sentence: Faker::TvShows::Community.quotes)

    form = Organization::NoteForm.new(
      current_organization: organization,
      current_user: user,
      tiptap_document: note_document.to_json,
      note: note
    )

    assert_no_difference "Organization::Note.count" do
      form.save!
    end

    note = form.note.reload

    assert_equal organization, note.organization
    assert_equal old_original_author, note.original_author
    assert_equal note_document.as_json, note.tiptap_document.as_json
    assert_equal old_resource, note.resource
  end

  test "raises a validation error if tiptap_document is missing" do
    organization = organizations.organization_1
    user = users.moonlighter
    resource = organization_onsites.repeat_onsite_1

    form = Organization::NoteForm.new(
      current_organization: organization,
      current_user: user,
      tiptap_document: "",
      resource: resource
    )

    assert_raises ActiveRecord::RecordInvalid do
      form.save!
    end

    assert_equal true, form.errors.of_kind?(:tiptap_document, :blank)
  end

  test "raises a validation error if resource is missing" do
    organization = organizations.organization_1
    user = users.moonlighter
    note_document = example_tiptap_document

    form = Organization::NoteForm.new(
      current_organization: organization,
      current_user: user,
      tiptap_document: note_document.to_json,
      resource: nil
    )

    assert_raises ActiveRecord::RecordInvalid do
      form.save!
    end

    assert_equal true, form.errors.of_kind?(:resource, :blank)
  end

  test "raises a ActionPolicy::AuthorizationContextMissing error if the current_user is missing" do
    organization = organizations.organization_1
    resource = organization_onsites.repeat_onsite_1
    note_document = example_tiptap_document

    form = Organization::NoteForm.new(
      current_organization: organization,
      tiptap_document: note_document.to_json,
      resource: resource
    )

    assert_raises ActionPolicy::AuthorizationContextMissing do
      form.save!
    end
  end

  test "raises a NoMethodError error if the current_organization is missing" do
    user = users.moonlighter
    resource = organization_onsites.repeat_onsite_1
    note_document = example_tiptap_document

    assert_raises NoMethodError do
      Organization::NoteForm.new(
        current_user: user,
        tiptap_document: note_document.to_json,
        resource: resource
      )
    end
  end

  test "raises a validation error if the current_user cannot manage the new note" do
    organization = organizations.organization_1
    user = users.organization_3_owner
    resource = organization_onsites.repeat_onsite_1
    note_document = example_tiptap_document

    form = Organization::NoteForm.new(
      current_organization: organization,
      current_user: user,
      tiptap_document: note_document.to_json,
      resource: nil
    )

    assert_raises ActiveModel::ValidationError do
      form.save!
    end

    assert_equal true, form.errors.of_kind?(:base, :cannot_manage_notes)
  end

  test "raises a validation error if the current_user cannot manage the existing note" do
    seed "cases/note_editing"

    note = organization_notes.organization_1_note
    organization = note.organization
    user = users.organization_3_owner

    old_resource = note.resource

    note_document = example_tiptap_document(sentence: Faker::TvShows::Community.quotes)

    form = Organization::NoteForm.new(
      current_organization: organization,
      current_user: user,
      tiptap_document: note_document.to_json,
      note: note
    )

    assert_raises ActiveModel::ValidationError do
      form.save!
    end

    assert_equal true, form.errors.of_kind?(:base, :cannot_manage_notes)
  end

  test "raises a validation error if the resource is not part of the same organization" do
    organization = organizations.organization_1
    user = users.moonlighter
    resource = organization_jobs.new_customer_organization_2
    note_document = example_tiptap_document

    form = Organization::NoteForm.new(
      current_organization: organization,
      current_user: user,
      tiptap_document: note_document.to_json,
      resource: resource
    )

    assert_raises ActiveRecord::RecordInvalid do
      form.save!
    end

    assert_equal true, form.errors.of_kind?(:resource, :cannot_access_organization)
  end

  test "delegates persisted? and model_name to the underlying note" do
    organization = organizations.organization_1
    user = users.moonlighter
    resource = organization_onsites.repeat_onsite_1
    note_document = example_tiptap_document

    form = Organization::NoteForm.new(
      current_organization: organization,
      current_user: user,
      tiptap_document: note_document.to_json,
      resource: resource
    )

    assert_equal false, form.note.persisted?
    assert_equal false, form.persisted?

    assert_equal form.note.model_name, form.model_name

    form.save!

    assert_equal true, form.note.persisted?
    assert_equal true, form.persisted?

    assert_equal form.note.model_name, form.model_name
  end
end