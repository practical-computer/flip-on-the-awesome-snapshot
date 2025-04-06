# frozen_string_literal: true

class Organization::JobTaskRelationBuilder < PracticalFramework::RelationBuilders::Base
  def apply_filtering(scope:)
    if payload.dig(:filters, :label).present?
      scope = scope.label_includes(payload.dig(:filters, :label))
    end

    if payload.dig(:filters, :status).present?
      scope = scope.where(status: payload.dig(:filters, :status))
    end

    if payload.dig(:filters, :task_type).present?
      scope = scope.where(task_type: payload.dig(:filters, :task_type))
    end

    return scope
  end

  def first_order_sorting(scope:)
    case payload.dig(:sort_key)
    when "label"
      scope.order(label: payload.fetch(:sort_direction){ :asc })
    when "task_type"
      task_type_order_sorting(scope: scope)
    when "estimated_minutes"
      scope.order(estimated_minutes: payload.fetch(:sort_direction){ :asc })
    when "onsite_label"
      onsite_label_order_sorting(scope: scope)
    else
      status_order_sorting(scope: scope)
    end
  end

  def status_order_sorting(scope:)
    sort_direction = payload.fetch(:sort_direction){ "asc" }

    if sort_direction == "desc"
      return scope.descending_status
    else
      return scope.ascending_status
    end
  end

  def task_type_order_sorting(scope:)
    sort_direction = payload.fetch(:sort_direction){ "asc" }

    if sort_direction == "desc"
      return scope.descending_task_type
    else
      return scope.ascending_task_type
    end
  end

  def onsite_label_order_sorting(scope:)
    sort_direction = payload.fetch(:sort_direction){ "asc" }

    if sort_direction == "desc"
      return scope.descending_onsite_label
    else
      return scope.ascending_onsite_label
    end
  end

  def second_order_sorting(scope:)
    case payload.dig(:sort_key)
    when "label"
      return scope.ascending_status
    else
      return scope.order(label: :asc)
    end
  end
end