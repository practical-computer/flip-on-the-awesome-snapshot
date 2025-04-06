# frozen_string_literal: true

class Organization::OnsitesSummaryComponent < ApplicationComponent
  include Organization::Onsite::StatusColorVariant
  attr_accessor :onsites

  def initialize(onsites:)
    @onsites = onsites
  end

  def counts
    onsites.group(:status).count
  end

  def call
    tag.section(class: "wa-cluster") {
      safe_join(counts.map{|status, count| count_tag(status: status, count: count) })
    }
  end

  def count_tag(status:, count:)
    tag.wa_tag(variant: tag_color_variant(status: status).to_web_awesome) {
      tag.span(class: "wa-cluster:column"){
        safe_join([
          helpers.icon_text(
            icon: helpers.icon_set.onsite_status_icon(status: status),
            text: helpers.human_onsite_status(status: status),
            options: {class: "wa-gap-xs"}
          ),
          tag.wa_badge(count, pill: true)
        ])
      }
    }
  end

  def count_tag_classes(status:)
    helpers.class_names("onsite-status-badge")
  end
end
