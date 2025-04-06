# frozen_string_literal: true

class Organization::Onsite::PriorityBadgeComponent < ApplicationComponent
  attr_accessor :priority

  def initialize(priority:)
    @priority = priority
  end

  def call
    tag.wa_badge(variant: color_variant(priority: priority).to_web_awesome) {
      render(helpers.icon_set.onsite_priority_icon(priority: priority))
    }
  end

  def color_variant(priority:)
    case priority.to_sym
    when :regular_priority
      variant = :neutral
    when :high_priority
      variant = :warning
    end

    return PracticalViews::WebAwesome::StyleUtility::ColorVariant.new(variant: variant)
  end
end
