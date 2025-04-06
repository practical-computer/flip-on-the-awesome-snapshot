# frozen_string_literal: true

require "test_helper"

class Organization::JobRelationBuilderTest < ActiveSupport::TestCase
  include PracticalFramework::TestHelpers::RelationBuilderHelpers

  def build_instance(payload:, relation:)
    Organization::JobRelationBuilder.new(payload: payload, relation: relation)
  end

  test "apply_filtering: does nothing if no filters are given" do
    payload = {
      filters: {},
      sort_key: "name",
      sort_direction: "asc",
    }

    relation = organizations.organization_1.jobs

    instance = build_instance(payload: payload, relation: relation)

    assert_empty payload.dig(:filters)

    expected = relation

    assert_equal expected, relation
    new_relation = instance.apply_filtering(scope: relation)
    message = {expected_sql: expected.to_sql, actual_sql: new_relation.to_sql}
    assert_equal expected, new_relation, message
  end

  test "apply_filtering: ignores unknown filters" do
    payload = {
      filters: {
        blah: SecureRandom.hex
      },
      sort_key: "name",
      sort_direction: "asc",
    }

    relation = organizations.organization_1.jobs

    instance = build_instance(payload: payload, relation: relation)

    assert_equal [:blah], payload.dig(:filters).keys

    expected = relation

    assert_equal expected, relation
    new_relation = instance.apply_filtering(scope: relation)
    message = {expected_sql: expected.to_sql, actual_sql: new_relation.to_sql}
    assert_equal expected, new_relation, message
  end

  test "apply_filtering: filters by an entire job name if job_name is a given filter parameter" do
    job = organization_jobs.repeat_customer

    payload = {
      filters: {
        job_name: job.name
      }
    }

    relation = organizations.organization_1.jobs

    instance = build_instance(payload: payload, relation: relation)

    assert_equal job.name, payload.dig(:filters, :job_name)

    expected = relation.where(id: job.id)
    assert_relation_filtering_matches(expected: expected, relation: relation, instance: instance)
  end

  test "apply_filtering: filters by a partial job name if job_name is a given filter parameter" do
    job_in_maintenance_agreement = organization_jobs.maintenance_agreement_job_1

    name_filter = job_in_maintenance_agreement.name.split("//")[0]

    payload = {
      filters: {
        job_name: name_filter
      }
    }

    relation = organizations.organization_1.jobs

    instance = build_instance(payload: payload, relation: relation)

    assert_equal name_filter, payload.dig(:filters, :job_name)

    expected = relation.job_name_includes(name_filter)
    assert_relation_filtering_matches(expected: expected, relation: relation, instance: instance)
  end

  test "apply_filtering: filters to the given status" do
    payload = {
      filters: {
        status: [:archived]
      }
    }

    relation = organizations.organization_1.jobs

    instance = build_instance(payload: payload, relation: relation)

    assert_equal [:archived], payload.dig(:filters, :status)

    expected = relation.where(status: :archived)
    assert_relation_filtering_matches(expected: expected, relation: relation, instance: instance)
  end

  test "apply_filtering: combines both job_name and status filters" do
    job_in_maintenance_agreement = organization_jobs.maintenance_agreement_job_1

    name_filter = job_in_maintenance_agreement.name.split("//")[0]

    payload = {
      filters: {
        job_name: name_filter,
        status: [:archived]
      }
    }

    relation = organizations.organization_1.jobs

    instance = build_instance(payload: payload, relation: relation)

    assert_equal name_filter, payload.dig(:filters, :job_name)
    assert_equal [:archived], payload.dig(:filters, :status)

    expected = relation.where(id: [organization_jobs.maintenance_agreement_job_1, organization_jobs.maintenance_agreement_job_4])
    assert_relation_filtering_matches(expected: expected, relation: relation, instance: instance)
  end

  test "apply_ordering: without any sort_key values sets the default sort order of ascending_status, then ascending name" do
    payload = {
      filters: {
        job_name: "blah"
      }
    }

    relation = organizations.organization_1.jobs

    instance = build_instance(payload: payload, relation: relation)

    assert_nil payload.dig(:sort_key)
    assert_nil payload.dig(:sort_direction)

    expected = relation.ascending_status.order(name: :asc)
    assert_relation_ordering_matches(expected: expected, relation: relation, instance: instance)
  end

  test "apply_ordering: uses the default sort order when given an unknown sort_key" do
    payload = {
      filters: {
        job_name: "blah",
      },
      sort_key: "blah",
    }

    relation = organizations.organization_1.jobs

    instance = build_instance(payload: payload, relation: relation)

    expected = relation.ascending_status.order(name: :asc)
    assert_relation_ordering_matches(expected: expected, relation: relation, instance: instance)
  end

  test "apply_ordering: uses the name ASC as the first_order_sorting, and ascending_status as the second_order_sorting" do
    payload = {
      filters: {
        job_name: "blah",
      },
      sort_key: "name",
      sort_direction: "asc",
    }

    relation = organizations.organization_1.jobs

    instance = build_instance(payload: payload, relation: relation)

    assert_equal "name", payload.dig(:sort_key)
    assert_equal "asc", payload.dig(:sort_direction)

    expected = relation.order(name: :asc).ascending_status
    assert_relation_ordering_matches(expected: expected, relation: relation, instance: instance)
  end

  test "apply_ordering: uses the name DESC as the first_order_sorting, and ascending_status as the second_order_sorting" do
    payload = {
      filters: {
        job_name: "blah",
      },
      sort_key: "name",
      sort_direction: "desc",
    }

    relation = organizations.organization_1.jobs

    instance = build_instance(payload: payload, relation: relation)

    assert_equal "name", payload.dig(:sort_key)
    assert_equal "desc", payload.dig(:sort_direction)

    expected = relation.order(name: :desc).ascending_status
    assert_relation_ordering_matches(expected: expected, relation: relation, instance: instance)
  end

  test "apply_ordering: uses the ascending_status as the first_order_sorting, and name ASC as the second_order_sorting" do
    payload = {
      filters: {
        job_name: "blah",
      },
      sort_key: "status",
      sort_direction: "asc",
    }

    relation = organizations.organization_1.jobs

    instance = build_instance(payload: payload, relation: relation)

    assert_equal "status", payload.dig(:sort_key)
    assert_equal "asc", payload.dig(:sort_direction)

    expected = relation.ascending_status.order(name: :asc)
    assert_relation_ordering_matches(expected: expected, relation: relation, instance: instance)
  end

  test "apply_ordering: uses the descending_status as the first_order_sorting, and name ASC as the second_order_sorting" do
    payload = {
      filters: {
        job_name: "blah",
      },
      sort_key: "status",
      sort_direction: "desc",
    }

    relation = organizations.organization_1.jobs

    instance = build_instance(payload: payload, relation: relation)

    assert_equal "status", payload.dig(:sort_key)
    assert_equal "desc", payload.dig(:sort_direction)

    expected = relation.descending_status.order(name: :asc)
    assert_relation_ordering_matches(expected: expected, relation: relation, instance: instance)
  end
end