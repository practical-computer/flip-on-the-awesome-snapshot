# frozen_string_literal: true

require "test_helper"

class Organization::JobFormTest < ActiveSupport::TestCase
  include PracticalFramework::TestHelpers::TiptapDocumentHelpers

  test "can create a new job without a note" do
    organization = organizations.organization_1
    user = users.moonlighter
    name = Faker::Company.name

    form = Organization::JobForm.new(
      current_organization: organization,
      current_user: user,
      name: name,
      note: ""
    )

    assert_difference "Organization::Job.count", +1 do
    assert_no_difference "Organization::Note.count" do
      form.save!
    end
    end

    job = form.job

    assert_equal organization, job.organization
    assert_equal user, job.original_creator
    assert_equal name, job.name
    assert_nil job.note
    assert_equal true, job.active?
  end

  test "can create a new job with a note" do
    organization = organizations.organization_1
    user = users.moonlighter
    name = Faker::Company.name
    note_document = example_tiptap_document

    form = Organization::JobForm.new(
      current_organization: organization,
      current_user: user,
      name: name,
      note: note_document.to_json
    )

    assert_difference "Organization::Job.count", +1 do
    assert_difference "Organization::Note.count", +1 do
      form.save!
    end
    end

    job = form.job

    assert_equal organization, job.organization
    assert_equal user, job.original_creator
    assert_equal name, job.name
    assert_equal note_document.as_json, job.note.tiptap_document.as_json
    assert_equal true, job.active?
  end

  test "ignores creating a new job with the archived status" do
    organization = organizations.organization_1
    user = users.moonlighter
    name = Faker::Company.name
    note_document = example_tiptap_document

    form = Organization::JobForm.new(
      current_organization: organization,
      current_user: user,
      name: name,
      status: :archived,
      note: note_document.to_json
    )

    assert_difference "Organization::Job.count", +1 do
    assert_difference "Organization::Note.count", +1 do
      form.save!
    end
    end

    job = form.job

    assert_equal organization, job.organization
    assert_equal user, job.original_creator
    assert_equal name, job.name
    assert_equal note_document.as_json, job.note.tiptap_document.as_json
    assert_equal true, job.active?
  end

  test "uses the existing tiptap_document as the note attribute for an existing job" do
    existing_job = organization_jobs.repeat_customer
    organization = existing_job.organization
    user = users.moonlighter

    tiptap_document = example_tiptap_document
    note = existing_job.create_note!(organization: organization, original_author: user, tiptap_document: tiptap_document)

    form = Organization::JobForm.new(
      current_organization: organization,
      current_user: user,
      job: existing_job,
      name: existing_job.name
    )

    assert_equal tiptap_document.to_json, form.note
  end

  test "uses the existing name as the name attribute for an existing job" do
    existing_job = organization_jobs.repeat_customer
    organization = existing_job.organization
    user = users.moonlighter

    form = Organization::JobForm.new(
      current_organization: organization,
      current_user: user,
      job: existing_job,
      name: existing_job.name
    )

    assert_equal existing_job.name, form.name
  end

  test "can update an existing job without a note" do
    existing_job = organization_jobs.repeat_customer
    organization = existing_job.organization
    user = users.moonlighter

    new_name = Faker::Company.name

    form = Organization::JobForm.new(
      current_organization: organization,
      current_user: user,
      job: existing_job,
      name: new_name
    )

    assert_no_difference "Organization::Job.count" do
    assert_no_difference "Organization::Note.count" do
      form.save!
    end
    end

    existing_job.reload
    assert_equal organization, existing_job.organization
    assert_equal new_name, existing_job.name
    assert_nil existing_job.note
  end

  test "can clear out an existing note" do
    existing_job = organization_jobs.repeat_customer
    organization = existing_job.organization
    user = users.moonlighter

    old_name = existing_job.name

    tiptap_document = example_tiptap_document
    note = existing_job.create_note!(organization: organization, original_author: user, tiptap_document: tiptap_document)

    form = Organization::JobForm.new(
      current_organization: organization,
      current_user: user,
      job: existing_job,
      name: old_name,
      note: ""
    )

    assert_no_difference "Organization::Job.count" do
    assert_difference "Organization::Note.count", -1 do
      form.save!
    end
    end

    existing_job.reload
    assert_equal organization, existing_job.organization
    assert_equal old_name, existing_job.name
    assert_nil existing_job.note
  end

  test "can update an existing job with a new name & note" do
    existing_job = organization_jobs.repeat_customer
    organization = existing_job.organization
    user = users.moonlighter

    new_name = Faker::Company.name
    note_document = example_tiptap_document

    form = Organization::JobForm.new(
      current_organization: organization,
      current_user: user,
      job: existing_job,
      name: new_name,
      note: note_document.to_json
    )

    assert_no_difference "Organization::Job.count" do
    assert_difference "Organization::Note.count", +1 do
      form.save!
    end
    end

    existing_job.reload

    assert_equal organization, existing_job.organization
    assert_equal new_name, existing_job.name
    assert_equal note_document.as_json, existing_job.note.tiptap_document.as_json
  end

  test "can update an existing job with a note only" do
    existing_job = organization_jobs.repeat_customer
    organization = existing_job.organization
    user = users.moonlighter

    old_name = existing_job.name
    note_document = example_tiptap_document

    form = Organization::JobForm.new(
      current_organization: organization,
      current_user: user,
      job: existing_job,
      name: existing_job.name,
      note: note_document.to_json
    )

    assert_no_difference "Organization::Job.count" do
    assert_difference "Organization::Note.count", +1 do
      form.save!
    end
    end

    existing_job.reload
    assert_equal organization, existing_job.organization
    assert_equal old_name, existing_job.name
    assert_equal note_document.as_json, existing_job.note.tiptap_document.as_json
  end

  test "can update an existing job's note" do
    existing_job = organization_jobs.repeat_customer
    organization = existing_job.organization
    user = users.moonlighter

    existing_job.create_note!(
      organization: organization,
      original_author: users.organization_1_department_head,
      tiptap_document: example_tiptap_document
    )

    old_name = existing_job.name
    note_document = example_tiptap_document(sentence: Faker::TvShows::Community.quotes)

    form = Organization::JobForm.new(
      current_organization: organization,
      current_user: user,
      job: existing_job,
      name: existing_job.name,
      note: note_document.to_json
    )

    assert_no_difference "Organization::Job.count" do
    assert_no_difference "Organization::Note.count" do
      form.save!
    end
    end

    existing_job.reload
    assert_equal organization, existing_job.organization
    assert_equal old_name, existing_job.name
    assert_equal note_document.as_json, existing_job.note.tiptap_document.as_json
  end

  test "can update a job's status" do
    existing_job = organization_jobs.repeat_customer
    organization = existing_job.organization
    user = users.moonlighter

    existing_job.tasks.todo.update_all(status: :cancelled)

    assert_equal true, existing_job.active?
    assert_equal true, existing_job.can_be_archived?

    new_name = Faker::Company.name

    form = Organization::JobForm.new(
      current_organization: organization,
      current_user: user,
      job: existing_job,
      name: new_name,
      status: :archived
    )

    assert_no_difference "Organization::Job.count" do
    assert_no_difference "Organization::Note.count" do
      form.save!
    end
    end

    existing_job.reload
    assert_equal organization, existing_job.organization
    assert_equal new_name, existing_job.name
    assert_nil existing_job.note
    assert_equal true, existing_job.archived?
  end

  test "can reactivate an archived job" do
    existing_job = organization_jobs.archived_job
    organization = existing_job.organization
    user = users.moonlighter

    assert_equal true, existing_job.archived?

    new_name = Faker::Company.name

    form = Organization::JobForm.new(
      current_organization: organization,
      current_user: user,
      job: existing_job,
      name: new_name,
      status: :active
    )

    assert_no_difference "Organization::Job.count" do
    assert_no_difference "Organization::Note.count" do
      form.save!
    end
    end

    existing_job.reload
    assert_equal organization, existing_job.organization
    assert_equal new_name, existing_job.name
    assert_nil existing_job.note
    assert_equal true, existing_job.active?
  end

  test "can update only the job's status" do
    existing_job = organization_jobs.repeat_customer
    organization = existing_job.organization
    user = users.moonlighter

    existing_job.tasks.todo.update_all(status: :cancelled)

    assert_equal true, existing_job.active?
    assert_equal true, existing_job.can_be_archived?

    form = Organization::JobForm.new(
      current_organization: organization,
      current_user: user,
      job: existing_job,
      status: :archived
    )

    assert_no_difference "Organization::Job.count" do
    assert_no_difference "Organization::Note.count" do
      form.save!
    end
    end

    existing_job.reload
    assert_equal true, existing_job.archived?
  end

  test "does not change the job's original_creator" do
    existing_job = organization_jobs.repeat_customer
    organization = existing_job.organization
    user = users.organization_1_owner

    new_name = Faker::Company.name
    original_creator = existing_job.original_creator

    assert_not_equal user, original_creator

    form = Organization::JobForm.new(
      current_organization: organization,
      current_user: user,
      job: existing_job,
      name: new_name
    )

    assert_no_difference "Organization::Job.count" do
    assert_no_difference "Organization::Note.count" do
      form.save!
    end
    end

    existing_job.reload
    assert_equal organization, existing_job.organization
    assert_equal original_creator, existing_job.original_creator
  end

  test "raises a validation error if the name is missing" do
    organization = organizations.organization_2
    user = users.moonlighter

    form = Organization::JobForm.new(
      current_organization: organization,
      current_user: user,
      name: ""
    )

    assert_raises ActiveRecord::RecordInvalid do
      form.save!
    end

    assert_equal true, form.errors.of_kind?(:name, :blank)
  end

  test "raises a validation error if the name is taken" do
    existing_job = organization_jobs.repeat_customer
    organization = existing_job.organization
    user = users.moonlighter

    form = Organization::JobForm.new(
      current_organization: organization,
      current_user: user,
      name: existing_job.name
    )

    assert_raises ActiveRecord::RecordInvalid do
      form.save!
    end

    assert_equal true, form.errors.of_kind?(:name, :taken)
  end

  test "raises a ActionPolicy::AuthorizationContextMissing error if the current_user is missing" do
    organization = organizations.organization_2

    form = Organization::JobForm.new(
      current_organization: organization,
      name: ""
    )

    assert_raises ActionPolicy::AuthorizationContextMissing do
      form.save!
    end
  end

  test "raises an ActionPolicy::AuthorizationContextMissing error if the current_organization is missing" do
    existing_job = organization_jobs.repeat_customer
    user = users.moonlighter

    form = Organization::JobForm.new(
      current_user: user,
      job: existing_job,
      name: ""
    )

    assert_raises ActionPolicy::AuthorizationContextMissing do
      form.save!
    end
  end

  test "raises a validation error if the current_user cannot manage the new job" do
    organization = organizations.organization_1
    user = users.organization_3_owner
    name = Faker::Company.name

    form = Organization::JobForm.new(
      current_organization: organization,
      current_user: user,
      name: name
    )

    assert_raises ActiveModel::ValidationError do
      form.save!
    end

    assert_equal true, form.errors.of_kind?(:base, :cannot_manage_jobs)
  end

  test "raises a validation error if the current_user cannot manage the existing job" do
    existing_job = organization_jobs.repeat_customer
    organization = existing_job.organization
    user = users.organization_3_owner
    name = Faker::Company.name

    form = Organization::JobForm.new(
      current_organization: organization,
      current_user: user,
      name: name
    )

    assert_raises ActiveModel::ValidationError do
      form.save!
    end

    assert_equal true, form.errors.of_kind?(:base, :cannot_manage_jobs)
  end

  test "delegates persisted? and model_name to the underlying job" do
    organization = organizations.organization_1
    user = users.moonlighter

    name = Faker::Company.name

    form = Organization::JobForm.new(
      current_organization: organization,
      current_user: user,
      name: name
    )

    assert_equal false, form.job.persisted?
    assert_equal false, form.persisted?

    assert_equal form.job.model_name, form.model_name

    form.save!

    assert_equal true, form.job.persisted?
    assert_equal true, form.persisted?

    assert_equal form.job.model_name, form.model_name
  end

  test "can create a new job without a google place" do
    organization = organizations.organization_1
    user = users.moonlighter
    name = Faker::Company.name

    form = Organization::JobForm.new(
      current_organization: organization,
      current_user: user,
      name: name,
      google_place: ""
    )

    assert_difference "Organization::Job.count", +1 do
    assert_no_difference "Organization::Note.count" do
      form.save!
    end
    end

    job = form.job

    assert_equal organization, job.organization
    assert_equal user, job.original_creator
    assert_equal name, job.name
    assert_nil job.google_place
    assert_equal true, job.active?
  end

  test "can create a new job with a google place" do
    google_place = google_places.resident_1
    google_places_json = JSON.generate({place_id: google_place.google_place_api_id,
                                        formatted_address: google_place.human_address
                                      })

    organization = organizations.organization_1
    user = users.moonlighter
    name = Faker::Company.name

    form = Organization::JobForm.new(
      current_organization: organization,
      current_user: user,
      name: name,
      google_place: google_places_json
    )

    assert_difference "Organization::Job.count", +1 do
    assert_no_difference "Organization::Note.count" do
      form.save!
    end
    end

    job = form.job

    assert_equal organization, job.organization
    assert_equal user, job.original_creator
    assert_equal name, job.name
    assert_equal google_place, job.google_place
    assert_equal true, job.active?
  end

  test "uses the existing google_place as the google_place attribute for an existing job" do
    existing_job = organization_jobs.repeat_customer
    organization = existing_job.organization
    user = users.moonlighter

    google_place = google_places.resident_1
    existing_job.update!(google_place: google_place)

    form = Organization::JobForm.new(
      current_organization: organization,
      current_user: user,
      job: existing_job,
      name: existing_job.name
    )

    assert_equal google_place, form.google_place
  end

  test "can update an existing job without a google_place" do
    existing_job = organization_jobs.repeat_customer
    organization = existing_job.organization
    user = users.moonlighter

    new_name = Faker::Company.name

    form = Organization::JobForm.new(
      current_organization: organization,
      current_user: user,
      job: existing_job,
      name: new_name
    )

    assert_no_difference "Organization::Job.count" do
    assert_no_difference "Organization::Note.count" do
      form.save!
    end
    end

    existing_job.reload
    assert_equal organization, existing_job.organization
    assert_equal new_name, existing_job.name
    assert_nil existing_job.google_place
  end

  test "can clear out an existing google_place" do
    existing_job = organization_jobs.repeat_customer
    organization = existing_job.organization
    user = users.moonlighter

    old_name = existing_job.name

    google_place = google_places.resident_1
    existing_job.update!(google_place: google_place)

    form = Organization::JobForm.new(
      current_organization: organization,
      current_user: user,
      job: existing_job,
      name: existing_job.name,
      google_place: ""
    )

    assert_no_difference "Organization::Job.count" do
    assert_no_difference "GooglePlace.count" do
      form.save!
    end
    end

    existing_job.reload
    assert_equal organization, existing_job.organization
    assert_equal old_name, existing_job.name
    assert_nil form.google_place
  end

  test "can update an existing job with a new name & google_place" do
    existing_job = organization_jobs.repeat_customer
    organization = existing_job.organization
    user = users.moonlighter

    new_name = Faker::Company.name

    google_place = google_places.resident_1
    existing_job.update!(google_place: google_place)

    new_google_place = google_places.business

    form = Organization::JobForm.new(
      current_organization: organization,
      current_user: user,
      job: existing_job,
      name: new_name,
      google_place: new_google_place
    )

    assert_no_difference "Organization::Job.count" do
    assert_no_difference "GooglePlace.count" do
      form.save!
    end
    end

    existing_job.reload
    assert_equal organization, existing_job.organization
    assert_equal new_name, existing_job.name
    assert_equal new_google_place, form.google_place
  end

  test "can update an existing job with a google_place only" do
    existing_job = organization_jobs.repeat_customer
    organization = existing_job.organization
    user = users.moonlighter

    old_name = existing_job.name

    google_place = google_places.resident_1
    existing_job.update!(google_place: google_place)

    new_google_place = google_places.business

    form = Organization::JobForm.new(
      current_organization: organization,
      current_user: user,
      job: existing_job,
      name: existing_job.name,
      google_place: new_google_place
    )

    assert_no_difference "Organization::Job.count" do
    assert_no_difference "GooglePlace.count" do
      form.save!
    end
    end

    existing_job.reload
    assert_equal organization, existing_job.organization
    assert_equal old_name, existing_job.name
    assert_equal new_google_place, form.google_place
  end
end