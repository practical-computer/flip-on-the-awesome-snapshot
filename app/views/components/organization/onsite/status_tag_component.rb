# frozen_string_literal: true

class Organization::Onsite::StatusTagComponent < ApplicationComponent
  include Organization::Onsite::StatusColorVariant
  attr_accessor :onsite
  delegate :status, to: :onsite

  def initialize(onsite:)
    self.onsite = onsite
  end

  def call
    tag.wa_tag(variant: tag_color_variant(status: status).to_web_awesome) {
      helpers.icon_text(
        icon: helpers.icon_set.onsite_status_icon(status: status),
        text: helpers.human_onsite_status(status: status),
        options: {class: "wa-gap-xs"}
      )
    }
  end
end
