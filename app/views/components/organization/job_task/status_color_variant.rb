# frozen_string_literal: true

module Organization::JobTask::StatusColorVariant
  extend ActiveSupport::Concern

  def color_variant(status:)
    case status.to_sym
    when :todo
      variant = :warning
    when :done
      variant = :success
    else :cancelled
      variant = :neutral
    end

    return PracticalViews::WebAwesome::StyleUtility::ColorVariant.new(variant: variant)
  end
end