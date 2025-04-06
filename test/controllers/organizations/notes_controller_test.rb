# frozen_string_literal: true

require "test_helper"

class Organizations::NotesControllerTest < ActionDispatch::IntegrationTest
  include PracticalFramework::TestHelpers::TiptapDocumentHelpers

  def assert_index_policies_applied(organization:, &block)
    assert_have_authorized_scope(type: :active_record_relation, with: Organization::NotePolicy, &block)
  end

  def assert_create_policies_applied(organization:, &block)
    assert_authorized_to(:show?, organization, with: OrganizationPolicy) do
      assert_authorized_to(:create?, nil, with: Organization::NotePolicy, &block)
    end
  end

  def assert_manage_policies_applied(organization:, note:, &block)
    assert_authorized_to(:show?, organization, with: OrganizationPolicy) do
      assert_authorized_to(:manage?, note, with: Organization::NotePolicy, &block)
    end
  end

  def assert_flash(type:, message:)
    if WebAwesomeTest.web_awesome?
      assert_flash_message(type: type, message: message, icon_name: 'note')
    else
      assert_flash_message(type: type, message: message, icon_name: '#note')
    end
  end

  test "index: lists all notes" do
    seed "cases/note_editing"

    user = users.moonlighter
    organization = organizations.organization_1
    sign_in(user)

    assert_not_empty organization.notes

    assert_index_policies_applied(organization: organization) do
      get organization_notes_url(organization)
    end

    assert_response :ok
    if WebAwesomeTest.web_awesome?
      assert_dom '.note .tiptap-document', count: organization.notes.count
    else
      assert_dom '.note.tiptap-document', count: organization.notes.count
    end
  end

  test "new: renders the form for a new note" do
    user = users.moonlighter
    organization = organizations.organization_1
    sign_in(user)

    resource = organization_onsites.repeat_onsite_1
    resource_gid = Organization::Note.sgid_for_resource(resource: resource)

    assert_create_policies_applied(organization: organization) do
      get new_organization_note_url(organization, resource_gid: resource_gid)
    end

    assert_response :ok
  end

  test "create: creates a new note and redirects to the resource" do
    user = users.moonlighter
    organization = organizations.organization_1
    sign_in(user)

    resource = organization_onsites.repeat_onsite_1
    resource_gid = Organization::Note.sgid_for_resource(resource: resource)

    tiptap_document = example_tiptap_document

    params = {
      organization_note: {
        tiptap_document: tiptap_document.to_json,
        resource_gid: resource_gid
      }
    }

    assert_create_policies_applied(organization: organization) do
    assert_difference "Organization::Note.count", +1 do
      post organization_notes_url(organization), params: params, as: :json
    end
    end

    new_note = organization.notes.last
    assert_json_redirected_to(onsite_url(organization, resource))

    message = I18n.t('dispatcher.notes.created_message')
    assert_flash(type: :success, message: message)

    assert_equal organization, new_note.organization
    assert_equal user, new_note.original_author
    assert_equal resource, new_note.resource
    assert_equal tiptap_document.as_json, new_note.tiptap_document.as_json
  end

  test "create: renders errors as JSON" do
    user = users.moonlighter
    organization = organizations.organization_1
    sign_in(user)

    resource = organization_onsites.repeat_onsite_1
    resource_gid = Organization::Note.sgid_for_resource(resource: resource)

    tiptap_document = "     "

    params = {
      organization_note: {
        tiptap_document: tiptap_document.to_json,
        resource_gid: resource_gid
      }
    }

    assert_create_policies_applied(organization: organization) do
    assert_no_difference "Organization::Note.count" do
      post organization_notes_url(organization), params: params, as: :json
    end
    end

    assert_response :bad_request
    assert_error_json_contains(
      container_id: "organization_note_tiptap_document_errors",
      element_id: "organization_note_tiptap_document",
      message: "can't be blank",
    )
  end

  test "create: renders errors as HTML" do
    user = users.moonlighter
    organization = organizations.organization_1
    sign_in(user)

    resource = organization_onsites.repeat_onsite_1
    resource_gid = Organization::Note.sgid_for_resource(resource: resource)

    tiptap_document = "     "

    params = {
      organization_note: {
        tiptap_document: tiptap_document.to_json,
        resource_gid: resource_gid
      }
    }

    assert_create_policies_applied(organization: organization) do
    assert_no_difference "Organization::Note.count" do
      post organization_notes_url(organization), params: params
    end
    end

    assert_response :bad_request

    assert_error_dom(
      container_id: "organization_note_tiptap_document_errors",
      message: "can't be blank",
    )
  end

  test "show: renders an existing note" do
    seed "cases/note_editing"

    user = users.moonlighter
    organization = organizations.organization_1
    sign_in(user)

    note = organization.notes.first

    assert_manage_policies_applied(organization: organization, note: note) do
      get organization_note_url(organization, note)
    end

    assert_response :ok

    assert_dom '.tiptap-document'
  end

  test "edit: renders the edit form for an existing note" do
    seed "cases/note_editing"

    user = users.moonlighter
    organization = organizations.organization_1
    sign_in(user)

    note = organization.notes.first

    assert_manage_policies_applied(organization: organization, note: note) do
      get edit_organization_note_url(organization, note)
    end

    assert_response :ok
  end

  test "update: updates the existing note and redirects to the resource" do
    seed "cases/note_editing"

    user = users.moonlighter
    organization = organizations.organization_1
    sign_in(user)

    note = organization.notes.first
    resource = note.resource

    tiptap_document = example_tiptap_document

    params = {
      organization_note: {tiptap_document: tiptap_document.to_json}
    }

    assert_manage_policies_applied(organization: organization, note: note) do
    assert_no_difference "Organization::Note.count" do
      patch organization_note_url(organization, note), params: params, as: :json
    end
    end

    note.reload
    assert_json_redirected_to(organization_job_url(organization, resource))

    message = I18n.t('dispatcher.notes.updated_message')
    assert_flash(type: :success, message: message)

    assert_equal tiptap_document.as_json, note.tiptap_document.as_json
  end

  test "update: renders errors as JSON" do
    seed "cases/note_editing"

    user = users.moonlighter
    organization = organizations.organization_1
    sign_in(user)

    note = organization.notes.first
    resource = note.resource

    old_tiptap_document = note.tiptap_document.as_json

    tiptap_document = example_tiptap_document

    params = {
      organization_note: {tiptap_document: "    "}
    }

    assert_manage_policies_applied(organization: organization, note: note) do
    assert_no_difference "Organization::Note.count" do
      patch organization_note_url(organization, note), params: params, as: :json
    end
    end

    note.reload

    assert_response :bad_request
    assert_error_json_contains(
      container_id: "organization_note_tiptap_document_errors",
      element_id: "organization_note_tiptap_document",
      message: "can't be blank",
    )

    assert_equal old_tiptap_document.as_json, note.tiptap_document.as_json
  end

  test "update: renders errors as HTML" do
    seed "cases/note_editing"

    user = users.moonlighter
    organization = organizations.organization_1
    sign_in(user)

    note = organization.notes.first
    resource = note.resource

    old_tiptap_document = note.tiptap_document.as_json

    tiptap_document = example_tiptap_document

    params = {
      organization_note: {tiptap_document: "    "}
    }

    assert_manage_policies_applied(organization: organization, note: note) do
    assert_no_difference "Organization::Note.count" do
      patch organization_note_url(organization, note), params: params
    end
    end

    note.reload

    assert_response :bad_request
    assert_error_dom(
      container_id: "organization_note_tiptap_document_errors",
      message: "can't be blank",
    )

    assert_equal old_tiptap_document.as_json, note.tiptap_document.as_json
  end

  test "destroy: destroys the existing note and redirects back to the resource" do
    seed "cases/note_editing"

    user = users.moonlighter
    organization = organizations.organization_1
    sign_in(user)

    note = organization.notes.first
    resource = note.resource

    assert_manage_policies_applied(organization: organization, note: note) do
    assert_difference "Organization::Note.count", -1 do
      delete organization_note_url(organization, note)
    end
    end

    message = I18n.t('dispatcher.notes.deleted_message')
    assert_flash(type: :notice, message: message)

    assert_nil Organization::Note.find_by(id: note.id)

    assert_redirected_to organization_job_url(organization, resource)
  end
end