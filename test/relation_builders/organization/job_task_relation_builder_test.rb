# frozen_string_literal: true

require "test_helper"

class Organization::JobTaskRelationBuilderTest < ActiveSupport::TestCase
  include PracticalFramework::TestHelpers::RelationBuilderHelpers

  def build_instance(payload:, relation:)
    Organization::JobTaskRelationBuilder.new(payload: payload, relation: relation)
  end

  test "apply_filtering: does nothing if no filters are given" do
    payload = {
      filters: {},
      sort_key: "label",
      sort_direction: "asc",
    }

    relation = organizations.organization_1.job_tasks
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
      sort_key: "label",
      sort_direction: "asc",
    }

    relation = organizations.organization_1.job_tasks
    instance = build_instance(payload: payload, relation: relation)

    assert_equal [:blah], payload.dig(:filters).keys

    expected = relation

    assert_equal expected, relation
    new_relation = instance.apply_filtering(scope: relation)
    message = {expected_sql: expected.to_sql, actual_sql: new_relation.to_sql}
    assert_equal expected, new_relation, message
  end

  test "apply_filtering: filters by an entire task label if is a given filter parameter" do
    task = organization_job_tasks.maintenance_agreement_job_task_1

    payload = {
      filters: {
        label: task.label
      }
    }

    relation = organizations.organization_1.job_tasks

    instance = build_instance(payload: payload, relation: relation)

    assert_equal task.label, payload.dig(:filters, :label)

    expected = relation.where(id: task.id)
    assert_relation_filtering_matches(expected: expected, relation: relation, instance: instance)
  end

  test "apply_filtering: filters by an partial task label if is a given filter parameter" do
    task = organization_job_tasks.maintenance_agreement_job_task_1

    label_filter = task.label.split("//")[0]

    payload = {
      filters: {
        label: label_filter
      }
    }

    relation = organizations.organization_1.job_tasks

    instance = build_instance(payload: payload, relation: relation)

    assert_equal label_filter, payload.dig(:filters, :label)

    expected = relation.label_includes(label_filter)
    assert_relation_filtering_matches(expected: expected, relation: relation, instance: instance)
  end

  test "apply_filtering: filters by to the given status" do
    payload = {
      filters: {
        status: [:done]
      }
    }

    relation = organizations.organization_1.job_tasks

    instance = build_instance(payload: payload, relation: relation)

    assert_equal [:done], payload.dig(:filters, :status)

    expected = relation.where(status: :done)
    assert_relation_filtering_matches(expected: expected, relation: relation, instance: instance)
  end

  test "apply_filtering: filters by to the given task_type" do
    payload = {
      filters: {
        task_type: [:onsite]
      }
    }

    relation = organizations.organization_1.job_tasks

    instance = build_instance(payload: payload, relation: relation)

    assert_equal [:onsite], payload.dig(:filters, :task_type)

    expected = relation.where(task_type: :onsite)
    assert_relation_filtering_matches(expected: expected, relation: relation, instance: instance)
  end

  test "apply_filtering: combines both label and status filters" do
    task = organization_job_tasks.maintenance_agreement_job_task_1

    label_filter = task.label.split("//")[0]

    payload = {
      filters: {
        label: label_filter,
        status: [:done]
      }
    }

    relation = organizations.organization_1.job_tasks

    instance = build_instance(payload: payload, relation: relation)

    assert_equal label_filter, payload.dig(:filters, :label)
    assert_equal [:done], payload.dig(:filters, :status)

    expected = relation.label_includes(label_filter).where(status: :done)
    assert_relation_filtering_matches(expected: expected, relation: relation, instance: instance)
  end

  test "apply_filtering: combines both task_type and status filters" do
    task = organization_job_tasks.maintenance_agreement_job_task_1

    label_filter = task.label.split("//")[0]

    payload = {
      filters: {
        task_type: [:offsite],
        status: [:done]
      }
    }

    relation = organizations.organization_1.job_tasks

    instance = build_instance(payload: payload, relation: relation)

    assert_equal [:offsite], payload.dig(:filters, :task_type)
    assert_equal [:done], payload.dig(:filters, :status)

    expected = relation.where(task_type: :offsite, status: :done)
    assert_relation_filtering_matches(expected: expected, relation: relation, instance: instance)
  end

  test "apply_ordering: without any sort_key values sets the default sort order of ascending_status, then ascending label" do
    payload = {
      filters: {
        label: "blah"
      }
    }

    relation = organizations.organization_1.job_tasks

    instance = build_instance(payload: payload, relation: relation)

    assert_nil payload.dig(:sort_key)
    assert_nil payload.dig(:sort_direction)

    expected = relation.ascending_status.order(label: :asc)
    assert_relation_ordering_matches(expected: expected, relation: relation, instance: instance)
  end

  test "apply_ordering: uses the default sort order when given an unknown sort_key" do
    payload = {
      filters: {
        label: "blah"
      },
      sort_key: "blah"
    }

    relation = organizations.organization_1.job_tasks

    instance = build_instance(payload: payload, relation: relation)

    expected = relation.ascending_status.order(label: :asc)
    assert_relation_ordering_matches(expected: expected, relation: relation, instance: instance)
  end

  test "apply_ordering: uses the label ASC as the first_order_sorting, and ascending_status as the second_order_sorting" do
    payload = {
      filters: {
        label: "blah"
      },
      sort_key: "label",
      sort_direction: "asc"
    }

    relation = organizations.organization_1.job_tasks

    instance = build_instance(payload: payload, relation: relation)

    assert_equal "label", payload.dig(:sort_key)
    assert_equal "asc", payload.dig(:sort_direction)

    expected = relation.order(label: :asc).ascending_status
    assert_relation_ordering_matches(expected: expected, relation: relation, instance: instance)
  end

  test "apply_ordering: uses the label DESC as the first_order_sorting, and ascending_status as the second_order_sorting" do
    payload = {
      filters: {
        label: "blah"
      },
      sort_key: "label",
      sort_direction: "desc"
    }

    relation = organizations.organization_1.job_tasks

    instance = build_instance(payload: payload, relation: relation)

    assert_equal "label", payload.dig(:sort_key)
    assert_equal "desc", payload.dig(:sort_direction)

    expected = relation.order(label: :desc).ascending_status
    assert_relation_ordering_matches(expected: expected, relation: relation, instance: instance)
  end

  test "apply_ordering: uses the estimated_minutes ASC as the first_order_sorting, and label ASC as the second_order_sorting" do
    payload = {
      filters: {
        label: "blah"
      },
      sort_key: "estimated_minutes",
      sort_direction: "asc"
    }

    relation = organizations.organization_1.job_tasks

    instance = build_instance(payload: payload, relation: relation)

    assert_equal "estimated_minutes", payload.dig(:sort_key)
    assert_equal "asc", payload.dig(:sort_direction)

    expected = relation.order(estimated_minutes: :asc, label: :asc)
    assert_relation_ordering_matches(expected: expected, relation: relation, instance: instance)
  end

  test "apply_ordering: uses the estimated_minutes DESC as the first_order_sorting, and label ASC as the second_order_sorting" do
    payload = {
      filters: {
        label: "blah"
      },
      sort_key: "estimated_minutes",
      sort_direction: "desc"
    }

    relation = organizations.organization_1.job_tasks

    instance = build_instance(payload: payload, relation: relation)

    assert_equal "estimated_minutes", payload.dig(:sort_key)
    assert_equal "desc", payload.dig(:sort_direction)

    expected = relation.order(estimated_minutes: :desc, label: :asc)
    assert_relation_ordering_matches(expected: expected, relation: relation, instance: instance)
  end

  test "apply_ordering: uses the ascending_task_type as the first_order_sorting, and label ASC as the second_order_sorting" do
    payload = {
      filters: {
        label: "blah"
      },
      sort_key: "task_type",
      sort_direction: "asc"
    }

    relation = organizations.organization_1.job_tasks

    instance = build_instance(payload: payload, relation: relation)

    assert_equal "task_type", payload.dig(:sort_key)
    assert_equal "asc", payload.dig(:sort_direction)

    expected = relation.ascending_task_type.order(label: :asc)
    assert_relation_ordering_matches(expected: expected, relation: relation, instance: instance)
  end

  test "apply_ordering: uses the descending_task_type as the first_order_sorting, and label ASC as the second_order_sorting" do
    payload = {
      filters: {
        label: "blah"
      },
      sort_key: "task_type",
      sort_direction: "desc"
    }

    relation = organizations.organization_1.job_tasks

    instance = build_instance(payload: payload, relation: relation)

    assert_equal "task_type", payload.dig(:sort_key)
    assert_equal "desc", payload.dig(:sort_direction)

    expected = relation.descending_task_type.order(label: :asc)
    assert_relation_ordering_matches(expected: expected, relation: relation, instance: instance)
  end

  test "apply_ordering: uses the ascending_status as the first_order_sorting, and label ASC as the second_order_sorting" do
    payload = {
      filters: {
        label: "blah"
      },
      sort_key: "status",
      sort_direction: "asc"
    }

    relation = organizations.organization_1.job_tasks

    instance = build_instance(payload: payload, relation: relation)

    assert_equal "status", payload.dig(:sort_key)
    assert_equal "asc", payload.dig(:sort_direction)

    expected = relation.ascending_status.order(label: :asc)
    assert_relation_ordering_matches(expected: expected, relation: relation, instance: instance)
  end

  test "apply_ordering: uses the descending_status as the first_order_sorting, and label ASC as the second_order_sorting" do
    payload = {
      filters: {
        label: "blah"
      },
      sort_key: "status",
      sort_direction: "desc"
    }

    relation = organizations.organization_1.job_tasks

    instance = build_instance(payload: payload, relation: relation)

    assert_equal "status", payload.dig(:sort_key)
    assert_equal "desc", payload.dig(:sort_direction)

    expected = relation.descending_status.order(label: :asc)
    assert_relation_ordering_matches(expected: expected, relation: relation, instance: instance)
  end

  test "apply_ordering: uses the organization_onsites.label ASC (NULLS LAST) as the first_order_sorting, and label ASC as the second_order_sorting" do
    payload = {
      filters: {
        label: "blah"
      },
      sort_key: "onsite_label",
      sort_direction: "asc"
    }

    relation = organizations.organization_1.job_tasks

    instance = build_instance(payload: payload, relation: relation)

    assert_equal "onsite_label", payload.dig(:sort_key)
    assert_equal "asc", payload.dig(:sort_direction)

    expected = relation.ascending_onsite_label.order(label: :asc)
    assert_relation_ordering_matches(expected: expected, relation: relation, instance: instance)
  end

  test "apply_ordering: uses the organization_onsites.label DESC (NULLS FIRST) as the first_order_sorting, and label ASC as the second_order_sorting" do
    payload = {
      filters: {
        label: "blah"
      },
      sort_key: "onsite_label",
      sort_direction: "desc"
    }

    relation = organizations.organization_1.job_tasks

    instance = build_instance(payload: payload, relation: relation)

    assert_equal "onsite_label", payload.dig(:sort_key)
    assert_equal "desc", payload.dig(:sort_direction)

    expected = relation.descending_onsite_label.order(label: :asc)
    assert_relation_ordering_matches(expected: expected, relation: relation, instance: instance)
  end
end