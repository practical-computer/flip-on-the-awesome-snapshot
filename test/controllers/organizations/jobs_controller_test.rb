# frozen_string_literal: true

require "test_helper"

class Organizations::JobsControllerTest < ActionDispatch::IntegrationTest
  include PracticalFramework::TestHelpers::TiptapDocumentHelpers

  def assert_index_policies_applied(organization:, &block)
    assert_have_authorized_scope(type: :active_record_relation, with: Organization::JobPolicy, &block)
  end

  def assert_create_policies_applied(organization:, &block)
    assert_authorized_to(:show?, organization, with: OrganizationPolicy) do
      assert_authorized_to(:create?, nil, with: Organization::JobPolicy, &block)
    end
  end

  def assert_manage_policies_applied(organization:, job:, &block)
    assert_authorized_to(:show?, organization, with: OrganizationPolicy) do
      assert_authorized_to(:manage?, job, with: Organization::JobPolicy, &block)
    end
  end

  def assert_flash_success(message:)
    if WebAwesomeTest.web_awesome?
      assert_flash_message(type: :success, message: message, icon_name: "house-building")
    else
      assert_flash_message(type: :success, message: message, icon_name: "#job")
    end
  end

  test "index: lists all jobs" do
    user = users.moonlighter
    organization = organizations.organization_1
    sign_in(user)

    assert_not_empty organization.jobs

    assert_index_policies_applied(organization: organization) do
      get organization_jobs_url(organization)
    end

    jobs_to_show = organization.jobs.active

    assert_response :ok
    jobs_to_show.each do |job|
      assert_dom 'td', text: job.name
    end
  end

  test "new: renders the form for a new job" do
    user = users.moonlighter
    organization = organizations.organization_1
    sign_in(user)

    assert_create_policies_applied(organization: organization) do
      get new_organization_job_url(organization)
    end

    assert_response :ok
  end

  test "create: creates a new job without a note" do
    user = users.moonlighter
    organization = organizations.organization_1
    sign_in(user)

    name = Faker::Company.name

    params = {
      organization_job: {name: name}
    }

    assert_create_policies_applied(organization: organization) do
    assert_difference "Organization::Job.count", +1 do
    assert_no_difference "Organization::Note.count" do
      post organization_jobs_url(organization), params: params, as: :json
    end
    end
    end

    new_job = organization.jobs.last

    assert_json_redirected_to(organization_job_url(organization, new_job))

    message = I18n.t('dispatcher.jobs.created_message')
    assert_flash_success(message: message)

    assert_equal organization, new_job.organization
    assert_equal user, new_job.original_creator
    assert_equal name, new_job.name
    assert_nil new_job.note
  end

  test "create: creates a new job with a note" do
    user = users.moonlighter
    organization = organizations.organization_1
    sign_in(user)

    name = Faker::Company.name
    note = example_tiptap_document

    params = {
      organization_job: {
        name: name,
        note: note.to_json
      }
    }

    assert_create_policies_applied(organization: organization) do
    assert_difference "Organization::Job.count", +1 do
    assert_difference "Organization::Note.count", +1 do
      post organization_jobs_url(organization), params: params, as: :json
    end
    end
    end

    new_job = organization.jobs.last

    assert_json_redirected_to(organization_job_url(organization, new_job))

    message = I18n.t('dispatcher.jobs.created_message')
    assert_flash_success(message: message)

    assert_equal organization, new_job.organization
    assert_equal user, new_job.original_creator
    assert_equal name, new_job.name
    assert_equal note.as_json, new_job.note.tiptap_document.as_json
  end

  test "create: creates a new job without a google_place" do
    user = users.moonlighter
    organization = organizations.organization_1
    sign_in(user)

    name = Faker::Company.name

    params = {
      organization_job: {name: name}
    }

    assert_create_policies_applied(organization: organization) do
    assert_difference "Organization::Job.count", +1 do
    assert_no_difference "Organization::Note.count" do
      post organization_jobs_url(organization), params: params, as: :json
    end
    end
    end

    new_job = organization.jobs.last

    assert_json_redirected_to(organization_job_url(organization, new_job))

    message = I18n.t('dispatcher.jobs.created_message')
    assert_flash_success(message: message)

    assert_equal organization, new_job.organization
    assert_equal user, new_job.original_creator
    assert_equal name, new_job.name
    assert_nil new_job.google_place
  end

  test "create: creates a new job with a google_place" do
    user = users.moonlighter
    organization = organizations.organization_1
    sign_in(user)

    name = Faker::Company.name
    google_place_json = {place_id: SecureRandom.hex, formatted_address: Faker::Address.full_address}

    params = {
      organization_job: {
        name: name,
        google_place: google_place_json.to_json
      }
    }

    assert_create_policies_applied(organization: organization) do
    assert_difference "Organization::Job.count", +1 do
    assert_difference "GooglePlace.count", +1 do
      post organization_jobs_url(organization), params: params, as: :json
    end
    end
    end

    new_job = organization.jobs.last

    assert_json_redirected_to(organization_job_url(organization, new_job))

    message = I18n.t('dispatcher.jobs.created_message')
    assert_flash_success(message: message)

    assert_equal organization, new_job.organization
    assert_equal user, new_job.original_creator
    assert_equal name, new_job.name
    assert_equal google_place_json[:place_id], new_job.google_place.google_place_api_id
    assert_equal google_place_json[:formatted_address], new_job.google_place.human_address
  end

  test "create: renders errors as JSON" do
    user = users.moonlighter
    organization = organizations.organization_1
    sign_in(user)

    name = "    "

    params = {
      organization_job: {name: name}
    }

    assert_create_policies_applied(organization: organization) do
    assert_no_difference "Organization::Job.count", +1 do
    assert_no_difference "Organization::Note.count" do
      post organization_jobs_url(organization), params: params, as: :json
    end
    end
    end

    assert_response :bad_request

    assert_error_json_contains(
      container_id: "organization_job_name_errors",
      element_id: "organization_job_name",
      message: "can't be blank",
    )
  end

  test "create: renders errors as HTML" do
    user = users.moonlighter
    organization = organizations.organization_1
    sign_in(user)

    name = "    "

    params = {
      organization_job: {name: name}
    }

    assert_create_policies_applied(organization: organization) do
    assert_no_difference "Organization::Job.count", +1 do
    assert_no_difference "Organization::Note.count" do
      post organization_jobs_url(organization), params: params
    end
    end
    end

    assert_response :bad_request

    assert_error_dom(
      container_id: "organization_job_name_errors",
      message: "can't be blank",
    )
  end

  test "show: renders an existing job" do
    user = users.moonlighter
    organization = organizations.organization_1
    sign_in(user)

    job = organization.jobs.first

    assert_manage_policies_applied(organization: organization, job: job) do
      get organization_job_url(organization, job)
    end

    assert_response :ok

    if WebAwesomeTest.web_awesome?
      assert_dom 'h2', text: job.name
    else
      assert_dom 'h1', text: job.name
    end
  end

  test "show: renders an existing job with a note" do
    user = users.moonlighter
    organization = organizations.organization_1
    sign_in(user)

    job = organization.jobs.first

    sentence = Faker::TvShows::Community.quotes

    note_document = example_tiptap_document(sentence: sentence)

    job.create_note!(tiptap_document: note_document, organization: organization, original_author: user)

    assert_manage_policies_applied(organization: organization, job: job) do
      get organization_job_url(organization, job)
    end

    assert_response :ok

    if WebAwesomeTest.web_awesome?
      assert_dom '.note .tiptap-document p', sentence
    else
      assert_dom '.note.tiptap-document p', sentence
    end
  end

  test "show: renders an existing job with a google_place" do
    user = users.moonlighter
    organization = organizations.organization_1
    sign_in(user)

    job = organization.jobs.first

    google_place = google_places.resident_2
    address = google_place.human_address
    job.update!(google_place: google_place)

    assert_manage_policies_applied(organization: organization, job: job) do
      get organization_job_url(organization, job)
    end

    assert_response :ok

    assert_dom 'address.google-place', address
  end

  test "edit: renders the edit form for the job" do
    user = users.moonlighter
    organization = organizations.organization_1
    sign_in(user)

    job = organization.jobs.first

    assert_manage_policies_applied(organization: organization, job: job) do
      get edit_organization_job_url(organization, job)
    end

    assert_response :ok
  end

  test "update: updates the existing job with a new name" do
    user = users.moonlighter
    organization = organizations.organization_1
    sign_in(user)

    job = organization.jobs.first

    note_document = example_tiptap_document
    job.create_note!(tiptap_document: note_document, organization: organization, original_author: user)

    new_name = Faker::Company.name

    params = {
      organization_job: {name: new_name}
    }

    assert_manage_policies_applied(organization: organization, job: job) do
    assert_no_difference "Organization::Job.count" do
    assert_no_difference "Organization::Note.count" do
      patch organization_job_url(organization, job), params: params, as: :json
    end
    end
    end

    job.reload
    assert_json_redirected_to(organization_job_url(organization, job))

    message = I18n.t('dispatcher.jobs.updated_message', job_name: new_name)
    assert_flash_success(message: message)

    assert_equal new_name, job.name
    assert_equal note_document.as_json, job.note.tiptap_document.as_json
  end

  test "update: updates the existing job with a new status" do
    user = users.moonlighter
    organization = organizations.organization_1
    sign_in(user)

    job = organization.jobs.active.first

    job.tasks.todo.update_all(status: :cancelled)

    existing_name = job.name

    assert_equal false, job.archived?

    params = {
      organization_job: {status: :archived}
    }

    assert_manage_policies_applied(organization: organization, job: job) do
    assert_no_difference "Organization::Job.count" do
    assert_no_difference "Organization::Note.count" do
      patch organization_job_url(organization, job), params: params, as: :json
    end
    end
    end

    job.reload
    assert_json_redirected_to(organization_job_url(organization, job))

    message = I18n.t('dispatcher.jobs.updated_message', job_name: existing_name)
    assert_flash_success(message: message)

    assert_equal existing_name, job.name
    assert_equal true, job.archived?
  end

  test "update: updates the existing job with a new note" do
    user = users.moonlighter
    organization = organizations.organization_1
    sign_in(user)

    job = organization.jobs.first

    note_document = example_tiptap_document
    job.create_note!(tiptap_document: note_document, organization: organization, original_author: user)

    existing_name = job.name
    new_note = example_tiptap_document(sentence: Faker::Company.name)

    params = {
      organization_job: {note: new_note.to_json}
    }

    assert_manage_policies_applied(organization: organization, job: job) do
    assert_no_difference "Organization::Job.count" do
    assert_no_difference "Organization::Note.count" do
      patch organization_job_url(organization, job), params: params, as: :json
    end
    end
    end

    job.reload
    assert_json_redirected_to(organization_job_url(organization, job))

    message = I18n.t('dispatcher.jobs.updated_message', job_name: existing_name)
    assert_flash_success(message: message)

    assert_equal existing_name, job.name
    assert_equal new_note.as_json, job.note.tiptap_document.as_json
  end

  test "update: updates the existing job with a new google_place" do
    user = users.moonlighter
    organization = organizations.organization_1
    sign_in(user)

    job = organization.jobs.first

    existing_name = job.name

    google_place = google_places.resident_2
    job.update!(google_place: google_place)

    google_place_api_id = SecureRandom.hex
    address = Faker::Address.full_address

    google_place_data = { place_id: google_place_api_id, formatted_address: address }

    params = {
      organization_job: {google_place: google_place_data.to_json}
    }

    assert_manage_policies_applied(organization: organization, job: job) do
    assert_no_difference "Organization::Job.count" do
    assert_difference "GooglePlace.count", +1 do
      patch organization_job_url(organization, job), params: params, as: :json
    end
    end
    end

    job.reload
    assert_json_redirected_to(organization_job_url(organization, job))

    message = I18n.t('dispatcher.jobs.updated_message', job_name: existing_name)
    assert_flash_success(message: message)

    assert_equal existing_name, job.name
    assert_equal google_place_api_id, job.google_place.google_place_api_id
    assert_equal address, job.google_place.human_address
  end

  test "update: renders errors as HTML" do
    user = users.moonlighter
    organization = organizations.organization_1
    sign_in(user)

    job = organization.jobs.first

    name = "     "

    params = {
      organization_job: {name: name}
    }

    assert_manage_policies_applied(organization: organization, job: job) do
    assert_no_difference "Organization::Job.count", +1 do
    assert_no_difference "Organization::Note.count" do
      patch organization_job_url(organization, job), params: params
    end
    end
    end

    assert_response :bad_request

    assert_error_dom(
      container_id: "organization_job_name_errors",
      message: "can't be blank",
    )
  end

  test "update: renders errors as JSON" do
    user = users.moonlighter
    organization = organizations.organization_1
    sign_in(user)

    job = organization.jobs.first

    name = "     "

    params = {
      organization_job: {name: name}
    }

    assert_manage_policies_applied(organization: organization, job: job) do
    assert_no_difference "Organization::Job.count", +1 do
    assert_no_difference "Organization::Note.count" do
      patch organization_job_url(organization, job), params: params, as: :json
    end
    end
    end

    assert_response :bad_request

    assert_error_json_contains(
      container_id: "organization_job_name_errors",
      element_id: "organization_job_name",
      message: "can't be blank",
    )
  end
end
