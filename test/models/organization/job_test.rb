# frozen_string_literal: true

require "test_helper"

class Organization::JobTest < ActiveSupport::TestCase
  def valid_new_job
    organizations.organization_1.jobs.build(
      name: Faker::Company.name,
      original_creator: users.organization_1_owner
    )
  end

  test "belongs_to :organization" do
    reflection = Organization::Job.reflect_on_association(:organization)
    assert_equal :belongs_to, reflection.macro
  end

  test "belongs_to :original_creator" do
    reflection = Organization::Job.reflect_on_association(:original_creator)
    assert_equal :belongs_to, reflection.macro
    assert_equal "User", reflection.class_name
  end

  test "has_one :note" do
    reflection = Organization::Job.reflect_on_association(:note)
    assert_equal :resource, reflection.options[:as]
    assert_equal "resource_type", reflection.type
    assert_equal :has_one, reflection.macro
  end

  test "has_many :onsites" do
    reflection = Organization::Job.reflect_on_association(:onsites)
    assert_equal :has_many, reflection.macro
  end

  test "belongs_to :google_place, optionally" do
    reflection = Organization::Job.reflect_on_association(:google_place)
    assert_equal :belongs_to, reflection.macro
    assert_equal true, reflection.options[:optional]
  end

  test "name: must be present and non-blank" do
    instance = organizations.organization_1.jobs.build(
      name: Faker::Company.name,
      original_creator: users.organization_1_owner
    )

    assert_equal true, instance.valid?
    instance.name = nil

    assert_equal false, instance.valid?
    assert_equal true, instance.errors.of_kind?(:name, :blank)

    instance.name = "    "

    assert_equal false, instance.valid?
    assert_equal true, instance.errors.of_kind?(:name, :blank)
  end

  test "name: must be unique for the organization" do
    existing_job = organization_jobs.repeat_customer

    new_job = existing_job.organization.jobs.build(
      name: existing_job.name,
      original_creator: users.moonlighter
    )

    assert_equal false, new_job.valid?
    assert_equal true, new_job.errors.of_kind?(:name, :taken)

    new_job.name = Faker::Company.name
    assert_equal true, new_job.valid?
  end

  test "validates that the original_creator has a membership in the organization on creation only" do
    job = valid_new_job

    other_user = users.organization_3_owner

    assert_not_includes other_user.organizations, job.organization

    job.original_creator = other_user

    assert_equal false, job.valid?
    assert_equal true, job.errors.of_kind?(:original_creator, :cannot_access_organization)

    job.original_creator = users.moonlighter
    assert_equal true, job.valid?

    job.original_creator = users.organization_1_department_head
    assert_equal true, job.valid?

    job.save!

    job.original_creator = users.organization_3_owner
    assert_equal true, job.valid?
  end

  test "scannable_ordering: orders by status, then name" do
    seed "cases/job_name_ordering"

    expected = [
      organization_jobs.active_a,
      organization_jobs.active_c,
      organization_jobs.archived_b,
      organization_jobs.archived_d
    ]

    assert_equal expected, organizations.ordered_organization.jobs.scannable_ordering
  end

  test "status: can only be archived if there are no todo tasks" do
    job = organization_jobs.repeat_customer

    assert_not_empty job.tasks.todo

    job.status = :archived

    assert_equal false, job.valid?
    assert_equal true, job.errors.of_kind?(:status, :still_has_todo_tasks)
  end
end
