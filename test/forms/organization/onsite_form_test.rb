# frozen_string_literal: true

require "test_helper"

class Organization::OnsiteFormTest < ActiveSupport::TestCase
  test "initializes a new onsite with the job's google_place" do
    organization = organizations.organization_1
    user = users.moonlighter
    job = organization_jobs.repeat_customer
    label = Faker::Team.name

    job.update!(google_place: google_places.business)

    form = Organization::OnsiteForm.new(
      current_organization: organization,
      current_user: user,
      job: job,
      label: label
    )

    assert_equal google_places.business, form.google_place
  end

  test "does not break if the job does not have a google_place" do
    organization = organizations.organization_1
    user = users.moonlighter
    job = organization_jobs.repeat_customer
    label = Faker::Team.name

    assert_nil job.google_place

    form = Organization::OnsiteForm.new(
      current_organization: organization,
      current_user: user,
      job: job,
      label: label
    )

    assert_nil form.google_place
  end

  test "can create a new onsite for an existing job" do
    organization = organizations.organization_1
    user = users.moonlighter
    job = organization_jobs.repeat_customer
    label = Faker::Team.name

    form = Organization::OnsiteForm.new(
      current_organization: organization,
      current_user: user,
      job: job,
      label: label
    )

    assert_difference "Organization::Onsite.count", +1 do
    assert_no_difference "Organization::Job.count" do
      form.save!
    end
    end

    onsite = form.onsite

    assert_equal job, onsite.job
    assert_equal user, onsite.original_creator
    assert_equal label, onsite.label
    assert_equal true, onsite.draft?
    assert_equal true, onsite.regular_priority?
  end

  test "raises a validation error if given an archived job" do
    organization = organizations.organization_1
    user = users.moonlighter
    job = organization_jobs.archived_job
    label = Faker::Team.name

    form = Organization::OnsiteForm.new(
      current_organization: organization,
      current_user: user,
      job: job,
      label: label
    )

    assert_no_difference "Organization::Onsite.count" do
    assert_no_difference "Organization::Job.count" do
    assert_raises ActiveModel::ValidationError do
      form.save!
    end
    end
    end

    assert_equal true, form.errors.of_kind?(:base, :archived_job)
  end

  test "creates an onsite with a given google_place" do
    google_place = google_places.resident_1
    google_places_json = JSON.generate({place_id: google_place.google_place_api_id,
                                        formatted_address: google_place.human_address
                                      })


    organization = organizations.organization_1
    user = users.moonlighter
    job = organization_jobs.repeat_customer
    label = Faker::Team.name

    form = Organization::OnsiteForm.new(
      current_organization: organization,
      current_user: user,
      job: job,
      label: label,
      google_place: google_places_json
    )

    assert_difference "Organization::Onsite.count", +1 do
    assert_no_difference "Organization::Job.count" do
      form.save!
    end
    end

    onsite = form.onsite

    assert_equal job, onsite.job
    assert_equal user, onsite.original_creator
    assert_equal label, onsite.label
    assert_equal true, onsite.draft?
    assert_equal true, onsite.regular_priority?
    assert_equal google_place, onsite.google_place
  end

  test "can create an onsite without a google_place" do
    organization = organizations.organization_1
    user = users.moonlighter
    job = organization_jobs.repeat_customer
    label = Faker::Team.name

    form = Organization::OnsiteForm.new(
      current_organization: organization,
      current_user: user,
      job: job,
      label: label,
      google_place: ""
    )

    assert_difference "Organization::Onsite.count", +1 do
    assert_no_difference "Organization::Job.count" do
      form.save!
    end
    end

    onsite = form.onsite

    assert_equal job, onsite.job
    assert_equal user, onsite.original_creator
    assert_equal label, onsite.label
    assert_equal true, onsite.draft?
    assert_equal true, onsite.regular_priority?
    assert_nil onsite.google_place
  end

  test "can create a new high_priority onsite" do
    organization = organizations.organization_1
    user = users.moonlighter
    job = organization_jobs.repeat_customer
    label = Faker::Team.name

    form = Organization::OnsiteForm.new(
      current_organization: organization,
      current_user: user,
      job: job,
      label: label,
      priority: "high_priority"
    )

    assert_difference "Organization::Onsite.count", +1 do
    assert_no_difference "Organization::Job.count" do
      form.save!
    end
    end

    onsite = form.onsite

    assert_equal job, onsite.job
    assert_equal user, onsite.original_creator
    assert_equal label, onsite.label
    assert_equal true, onsite.draft?
    assert_equal true, onsite.high_priority?
  end

  test "ignores creating a new onsite with the done status" do
    organization = organizations.organization_1
    user = users.moonlighter
    job = organization_jobs.repeat_customer
    label = Faker::Team.name

    form = Organization::OnsiteForm.new(
      current_organization: organization,
      current_user: user,
      job: job,
      label: label,
      status: :done
    )

    assert_difference "Organization::Onsite.count", +1 do
    assert_no_difference "Organization::Job.count" do
      form.save!
    end
    end

    onsite = form.onsite

    assert_equal job, onsite.job
    assert_equal user, onsite.original_creator
    assert_equal label, onsite.label
    assert_equal true, onsite.draft?
    assert_equal true, onsite.regular_priority?
  end

  test "uses the existing onsite's google_place when initializing" do
    organization = organizations.organization_1
    user = users.moonlighter
    onsite = organization_onsites.repeat_onsite_1
    job = onsite.job
    label = Faker::Team.name

    google_place = onsite.google_place
    assert_not_nil google_place

    job.update!(google_place: google_places.business)
    assert_not_equal google_place, job.google_place

    form = Organization::OnsiteForm.new(
      current_organization: organization,
      current_user: user,
      onsite: onsite
    )

    assert_equal google_place, form.google_place
  end

  test "returns nil if the existing onsite has no google_place" do
    organization = organizations.organization_1
    user = users.moonlighter
    onsite = organization_onsites.repeat_onsite_1
    job = onsite.job
    label = Faker::Team.name

    onsite.update!(google_place: nil)
    job.update!(google_place: google_places.business)

    form = Organization::OnsiteForm.new(
      current_organization: organization,
      current_user: user,
      onsite: onsite
    )

    assert_nil form.google_place
  end

  test "uses the existing job as the job for an existing onsite" do
    organization = organizations.organization_1
    user = users.moonlighter
    onsite = organization_onsites.repeat_onsite_1
    job = organization_jobs.repeat_customer
    label = Faker::Team.name

    other_job = organization.jobs.create!(name: Faker::Company.name,
                                          original_creator: user
                                         )

    form = Organization::OnsiteForm.new(
      current_organization: organization,
      current_user: user,
      onsite: onsite,
      label: label,
      job: other_job
    )

    assert_no_difference "Organization::Onsite.count" do
    assert_no_difference "Organization::Job.count" do
      form.save!
    end
    end

    assert_equal onsite, form.onsite
    onsite.reload

    assert_equal other_job, onsite.job
    assert_equal user, onsite.original_creator
    assert_equal label, onsite.label
    assert_equal true, onsite.draft?
    assert_equal true, onsite.regular_priority?
  end

  test "uses the existing label as the label for an existing onsite" do
    organization = organizations.organization_1
    user = users.moonlighter
    onsite = organization_onsites.repeat_onsite_1
    job = onsite.job
    label = organization_onsites.repeat_onsite_2.label

    form = Organization::OnsiteForm.new(
      current_organization: organization,
      current_user: user,
      onsite: onsite,
      label: label,
    )

    assert_no_difference "Organization::Onsite.count" do
    assert_no_difference "Organization::Job.count" do
      form.save!
    end
    end

    assert_equal onsite, form.onsite
    onsite.reload

    assert_equal job, onsite.job
    assert_equal user, onsite.original_creator
    assert_equal label, onsite.label
    assert_equal true, onsite.draft?
    assert_equal true, onsite.regular_priority?
  end

  test "can update an onsite's status" do
    organization = organizations.organization_1
    user = users.moonlighter
    onsite = organization_onsites.repeat_onsite_1
    job = onsite.job
    label = Faker::Team.name

    form = Organization::OnsiteForm.new(
      current_organization: organization,
      current_user: user,
      onsite: onsite,
      label: label,
      status: :in_progress
    )

    assert_no_difference "Organization::Onsite.count" do
    assert_no_difference "Organization::Job.count" do
      form.save!
    end
    end

    assert_equal onsite, form.onsite
    onsite.reload

    assert_equal job, onsite.job
    assert_equal user, onsite.original_creator
    assert_equal label, onsite.label
    assert_equal true, onsite.in_progress?
    assert_equal true, onsite.regular_priority?
  end

  test "can update an onsite's priority" do
    organization = organizations.organization_1
    user = users.moonlighter
    onsite = organization_onsites.repeat_onsite_1
    job = onsite.job
    label = Faker::Team.name

    form = Organization::OnsiteForm.new(
      current_organization: organization,
      current_user: user,
      onsite: onsite,
      label: label,
      priority: :high_priority
    )

    assert_no_difference "Organization::Onsite.count" do
    assert_no_difference "Organization::Job.count" do
      form.save!
    end
    end

    assert_equal onsite, form.onsite
    onsite.reload

    assert_equal job, onsite.job
    assert_equal user, onsite.original_creator
    assert_equal label, onsite.label
    assert_equal true, onsite.draft?
    assert_equal true, onsite.high_priority?
  end

  test "can update an onsite's label" do
    organization = organizations.organization_1
    user = users.moonlighter
    onsite = organization_onsites.repeat_onsite_1
    job = onsite.job
    label = Faker::Team.name

    form = Organization::OnsiteForm.new(
      current_organization: organization,
      current_user: user,
      onsite: onsite,
      label: label
    )

    assert_no_difference "Organization::Onsite.count" do
    assert_no_difference "Organization::Job.count" do
      form.save!
    end
    end

    assert_equal onsite, form.onsite
    onsite.reload

    assert_equal job, onsite.job
    assert_equal user, onsite.original_creator
    assert_equal label, onsite.label
    assert_equal true, onsite.draft?
    assert_equal true, onsite.regular_priority?
  end

  test "can update an onsite's google_place without affecting the job" do
    organization = organizations.organization_1
    user = users.moonlighter
    onsite = organization_onsites.repeat_onsite_1
    job = onsite.job
    label = Faker::Team.name

    google_place = google_places.resident_2
    google_places_json = JSON.generate({place_id: google_place.google_place_api_id,
                                        formatted_address: google_place.human_address
                                      })

    job_google_place = google_places.business
    job.update!(google_place: job_google_place)
    assert_not_equal google_place, job.google_place

    form = Organization::OnsiteForm.new(
      current_organization: organization,
      current_user: user,
      onsite: onsite,
      google_place: google_places_json
    )

    assert_no_difference "Organization::Onsite.count" do
    assert_no_difference "Organization::Job.count" do
      form.save!
    end
    end

    assert_equal onsite, form.onsite
    onsite.reload

    assert_equal google_place, onsite.google_place
    assert_equal job_google_place, job.reload.google_place
  end

  test "can clear out the onsite's google_place to a nil value" do
    organization = organizations.organization_1
    user = users.moonlighter
    onsite = organization_onsites.repeat_onsite_1
    job = onsite.job
    label = Faker::Team.name

    google_place = onsite.google_place
    assert_not_nil google_place

    job_google_place = google_places.business
    job.update!(google_place: job_google_place)
    assert_not_equal google_place, job.google_place

    form = Organization::OnsiteForm.new(
      current_organization: organization,
      current_user: user,
      onsite: onsite,
      google_place: ""
    )

    assert_no_difference "Organization::Onsite.count" do
    assert_no_difference "Organization::Job.count" do
      form.save!
    end
    end

    assert_equal onsite, form.onsite
    onsite.reload

    assert_nil onsite.google_place
    assert_equal job_google_place, job.reload.google_place
  end

  test "does not change the onsite's original_creator" do
    organization = organizations.organization_1
    user = users.organization_1_owner
    onsite = organization_onsites.repeat_onsite_1
    job = onsite.job
    label = Faker::Team.name
    old_original_creator = onsite.original_creator

    assert_not_equal user, old_original_creator

    form = Organization::OnsiteForm.new(
      current_organization: organization,
      current_user: user,
      onsite: onsite,
      label: label
    )

    assert_no_difference "Organization::Onsite.count" do
    assert_no_difference "Organization::Job.count" do
      form.save!
    end
    end

    assert_equal onsite, form.onsite
    onsite.reload

    assert_equal job, onsite.job
    assert_equal old_original_creator, onsite.original_creator
    assert_equal label, onsite.label
    assert_equal true, onsite.draft?
    assert_equal true, onsite.regular_priority?
  end

  test "can only update the onsite's status" do
    organization = organizations.organization_1
    user = users.moonlighter
    onsite = organization_onsites.repeat_onsite_1
    job = onsite.job
    old_label = onsite.label

    form = Organization::OnsiteForm.new(
      current_organization: organization,
      current_user: user,
      onsite: onsite,
      status: :in_progress
    )

    assert_no_difference "Organization::Onsite.count" do
    assert_no_difference "Organization::Job.count" do
      form.save!
    end
    end

    assert_equal onsite, form.onsite
    onsite.reload

    assert_equal job, onsite.job
    assert_equal user, onsite.original_creator
    assert_equal old_label, onsite.label
    assert_equal true, onsite.in_progress?
    assert_equal true, onsite.regular_priority?
  end

  test "can only update the onsite's priority" do
    organization = organizations.organization_1
    user = users.moonlighter
    onsite = organization_onsites.repeat_onsite_1
    job = onsite.job
    old_label = onsite.label

    form = Organization::OnsiteForm.new(
      current_organization: organization,
      current_user: user,
      onsite: onsite,
      priority: :high_priority
    )

    assert_no_difference "Organization::Onsite.count" do
    assert_no_difference "Organization::Job.count" do
      form.save!
    end
    end

    assert_equal onsite, form.onsite
    onsite.reload

    assert_equal job, onsite.job
    assert_equal user, onsite.original_creator
    assert_equal old_label, onsite.label
    assert_equal true, onsite.draft?
    assert_equal true, onsite.high_priority?
  end

  test "raises a validation error if the label is missing" do
    organization = organizations.organization_1
    user = users.moonlighter
    job = organization_jobs.repeat_customer

    form = Organization::OnsiteForm.new(
      current_organization: organization,
      current_user: user,
      job: job
    )

    assert_no_difference "Organization::Onsite.count" do
    assert_no_difference "Organization::Job.count" do
    assert_raises ActiveRecord::RecordInvalid do
      form.save!
    end
    end
    end

    assert_equal true, form.errors.of_kind?(:label, :blank)
  end

  test "raises a ActionPolicy::AuthorizationContextMissing error if the current_user is missing" do
    organization = organizations.organization_1
    existing_onsite = organization_onsites.repeat_onsite_1

    form = Organization::OnsiteForm.new(
      current_organization: organization,
      onsite: existing_onsite,
      label: ""
    )

    assert_raises ActionPolicy::AuthorizationContextMissing do
      form.save!
    end
  end

  test "raises a ActionPolicy::AuthorizationContextMissing error if the current_organization is missing" do
    existing_onsite = organization_onsites.repeat_onsite_1
    user = users.moonlighter

    form = Organization::OnsiteForm.new(
      current_user: user,
      onsite: existing_onsite,
      label: ""
    )

    assert_raises ActionPolicy::AuthorizationContextMissing do
      form.save!
    end
  end

  test "raises a validation error if the current_user cannot manage the new onsite" do
    organization = organizations.organization_1
    user = users.organization_3_owner
    job = organization_jobs.repeat_customer
    label = Faker::Team.name

    form = Organization::OnsiteForm.new(
      current_organization: organization,
      current_user: user,
      job: job,
      label: label
    )

    assert_raises ActiveModel::ValidationError do
      form.save!
    end

    assert_equal true, form.errors.of_kind?(:base, :cannot_manage_onsites)
  end

  test "raises a validation error if the current_user cannot manage the existing onsite" do
    organization = organizations.organization_1
    user = users.organization_3_owner
    onsite = organization_onsites.repeat_onsite_1
    label = Faker::Team.name

    form = Organization::OnsiteForm.new(
      current_organization: organization,
      current_user: user,
      onsite: onsite,
      label: label
    )

    assert_raises ActiveModel::ValidationError do
      form.save!
    end

    assert_equal true, form.errors.of_kind?(:base, :cannot_manage_onsites)
  end

  test "delegates persisted? and model_name to the underlying onsite" do
    organization = organizations.organization_1
    user = users.moonlighter
    job = organization_jobs.repeat_customer
    label = Faker::Team.name

    form = Organization::OnsiteForm.new(
      current_organization: organization,
      current_user: user,
      job: job,
      label: label
    )

    assert_equal false, form.onsite.persisted?
    assert_equal false, form.persisted?

    assert_equal form.onsite.model_name, form.model_name

    form.save!

    assert_equal true, form.onsite.persisted?
    assert_equal true, form.persisted?

    assert_equal form.onsite.model_name, form.model_name
  end
end