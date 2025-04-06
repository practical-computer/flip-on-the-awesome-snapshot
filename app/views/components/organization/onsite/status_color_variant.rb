# frozen_string_literal: true

module Organization::Onsite::StatusColorVariant
  extend ActiveSupport::Concern

  def tag_color_variant(status:)
    case status.to_sym
    when :scheduled, :in_progress
      variant = :warning
    when :done
      variant = :success
    else
      variant = :neutral
    end

    return PracticalViews::WebAwesome::StyleUtility::ColorVariant.new(variant: variant)
  end
end