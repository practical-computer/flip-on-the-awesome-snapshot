# frozen_string_literal: true

class Organization::OnsiteStatusBadge < Phlex::HTML
  attr_accessor :onsite

  def initialize(onsite:)
    self.onsite = onsite
  end

  def view_template
    span(class: tokens("badge labeled-badge compact-size rounded onsite-status-badge", onsite.status), title: title) {
      unsafe_raw helpers.onsite_status_icon(status: onsite.status)
      whitespace
      plain title
    }
  end

  def title
    helpers.human_onsite_status(status: onsite.status)
  end
end