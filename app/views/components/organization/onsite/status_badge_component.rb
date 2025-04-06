# frozen_string_literal: true

class Organization::Onsite::StatusBadgeComponent < ApplicationComponent
  include Organization::Onsite::StatusColorVariant
  attr_accessor :onsite
  delegate :status, to: :onsite

  def initialize(onsite:)
    @onsite = onsite
  end

  def call
    tag.wa_badge(variant: tag_color_variant(status: status).to_web_awesome) {
      render(helpers.icon_set.onsite_status_icon(status: status))
    }
  end
end
