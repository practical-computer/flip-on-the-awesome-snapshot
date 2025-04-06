# frozen_string_literal: true

class Organization::JobRelationBuilder < PracticalFramework::RelationBuilders::Base
  def apply_filtering(scope:)
    if payload.dig(:filters, :job_name).present?
      scope = scope.job_name_includes(payload.dig(:filters, :job_name))
    end

    if payload.dig(:filters, :status).present?
      scope = scope.where(status: payload.dig(:filters, :status))
    end

    return scope
  end

  def first_order_sorting(scope:)
    case payload.dig(:sort_key)
    when "name"
      return scope.order(name: payload.fetch(:sort_direction){ :asc })
    else
      sort_direction = payload.fetch(:sort_direction){ "asc" }

      if sort_direction == "desc"
        return scope.descending_status
      else
        return scope.ascending_status
      end
    end
  end

  def second_order_sorting(scope:)
    case payload.dig(:sort_key)
    when "name"
      return scope.ascending_status
    else
      return scope.order(name: :asc)
    end
  end
end