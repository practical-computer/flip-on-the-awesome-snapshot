# frozen_string_literal: true

require "test_helper"

class Organization::OnsiteTest < ActiveSupport::TestCase
  test "belongs_to: original_creator" do
    reflection = Organization::Onsite.reflect_on_association(:original_creator)
    assert_equal :belongs_to, reflection.macro
    assert_equal "User", reflection.class_name
  end

  test "belongs_to: job" do
    reflection = Organization::Onsite.reflect_on_association(:job)
    assert_equal :belongs_to, reflection.macro
  end

  test "has_one :organization, through: :job" do
    reflection = Organization::Onsite.reflect_on_association(:organization)
    assert_equal :job, reflection.options[:through]
    assert_equal :has_one, reflection.macro
  end

  test "belongs_to: google_place, optionally" do
    reflection = Organization::Onsite.reflect_on_association(:google_place)
    assert_equal :belongs_to, reflection.macro
    assert_equal true, reflection.options[:optional]
  end

  test "has_many: :notes, as: :resource" do
    reflection = Organization::Onsite.reflect_on_association(:notes)
    assert_equal :resource, reflection.options[:as]
    assert_equal "resource_type", reflection.type
    assert_equal :has_many, reflection.macro
  end

  test "label: must be present and non-blank" do
    instance = organizations.organization_1.onsites.build(
      label: Faker::Company.name,
      job: organization_jobs.repeat_customer,
      original_creator: users.organization_1_owner
    )

    assert_equal true, instance.valid?
    instance.label = nil

    assert_equal false, instance.valid?
    assert_equal true, instance.errors.of_kind?(:label, :blank)

    instance.label = "    "

    assert_equal false, instance.valid?
    assert_equal true, instance.errors.of_kind?(:label, :blank)
  end

  test "duplicate onsite labels can exist" do
    existing_onsite = organization_onsites.repeat_onsite_1

    new_onsite_same_job = existing_onsite.job.onsites.build(
      google_place: google_places.resident_2,
      original_creator: existing_onsite.original_creator,
      label: existing_onsite.label,
      status: :in_progress
    )

    assert_equal true, new_onsite_same_job.valid?
    assert_equal false, new_onsite_same_job.errors.of_kind?(:label, :taken)

    new_onsite_different_job = organization_jobs.archived_job.onsites.build(
      google_place: google_places.resident_2,
      original_creator: existing_onsite.original_creator,
      label: existing_onsite.label,
      status: :in_progress
    )

    assert_equal true, new_onsite_same_job.valid?
    assert_equal false, new_onsite_same_job.errors.of_kind?(:label, :taken)
  end

  test "available_to_assign_tasks_to" do
    status_values = Organization::Onsite.statuses.keys
    onsites_for_status = {}

    status_values.each do |status|
      onsites_for_status[status] = organization_jobs.repeat_customer.onsites.create!(
        label: Faker::Company.name,
        original_creator: users.organization_1_owner,
        status: status
      )
    end

    valid_statuses = ["draft", "scheduled", "in_progress"]
    matching_onsites = onsites_for_status.slice(*valid_statuses).values
    invalid_onsites = onsites_for_status.except(*valid_statuses).values

    assert_not_empty matching_onsites
    assert_not_empty invalid_onsites

    matching_onsites.each do |onsite|
      assert_includes organization_jobs.repeat_customer.onsites.available_to_assign_tasks_to, onsite
    end

    invalid_onsites.each do |onsite|
      assert_not_includes organization_jobs.repeat_customer.onsites.available_to_assign_tasks_to, onsite
    end
  end

  test "generates token for readonly_view that expires when readonly_token_generated_at is changed" do
    existing_onsite = organization_onsites.repeat_onsite_1

    token = existing_onsite.generate_token_for(:readonly_view)

    assert_equal existing_onsite, Organization::Onsite.find_by_token_for(:readonly_view, token)

    existing_onsite.update!(readonly_token_generated_at: Time.now.utc.advance(hour: 2))

    assert_nil Organization::Onsite.find_by_token_for(:readonly_view, token)
  end
end

class Organization::JobTaskCachingTest < ActiveJob::TestCase
  setup do
    perform_enqueued_jobs
  end

  test "queues up cache break when creating an onsite" do
    job = organization_jobs.repeat_customer
    onsite = job.onsites.build(
      label: Faker::Company.name,
      original_creator: users.organization_1_owner,
    )

    onsite.save!

    assert_enqueued_with(job: Caching::BreakTasksAndOnsitesCacheForOrganizationJob, args: [job: job])
    assert_no_enqueued_jobs(only: Caching::BreakTaskCacheForOrganizationOnsiteJob)
  end

  test "queues up cache break when updating a record" do
    onsite = organization_onsites.repeat_onsite_1
    job = onsite.job

    onsite.update!(label: Faker::Company.name)

    assert_enqueued_with(job: Caching::BreakTasksAndOnsitesCacheForOrganizationJob, args: [job: job])
    assert_no_enqueued_jobs(only: Caching::BreakTaskCacheForOrganizationOnsiteJob)
  end

  test "queues up cache breaks for the new & old jobs (moving)" do
    onsite = organization_onsites.repeat_onsite_1
    old_job = onsite.job

    new_job = organization_jobs.maintenance_agreement_job_1

    onsite.update!(job: new_job)

    assert_enqueued_with(job: Caching::BreakTasksAndOnsitesCacheForOrganizationJob, args: [job: old_job])
    assert_enqueued_with(job: Caching::BreakTasksAndOnsitesCacheForOrganizationJob, args: [job: new_job])
    assert_no_enqueued_jobs(only: Caching::BreakTaskCacheForOrganizationOnsiteJob)
  end

  test "queues up cache break when deleting a record" do
    onsite = organization_onsites.repeat_onsite_1
    job = onsite.job

    onsite.tasks.destroy_all
    perform_enqueued_jobs
    onsite.destroy

    assert_enqueued_with(job: Caching::BreakTasksAndOnsitesCacheForOrganizationJob, args: [job: job])
    assert_no_enqueued_jobs(only: Caching::BreakTaskCacheForOrganizationOnsiteJob)
  end
end