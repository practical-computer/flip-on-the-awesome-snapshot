# frozen_string_literal: true

class Organization::Job::StatusBadgeComponent < ApplicationComponent
  attr_accessor :status

  def initialize(status:)
    @status = status
  end

  def call
    tag.wa_badge(appearance: appearance, variant: variant) {
      safe_join([
        render(helpers.icon_set.job_status_icon(status: status)),
        helpers.human_job_status(status: status)
      ])
    }
  end

  def variant
    case status.to_sym
    when :active
      return :success
    when :archived
      return :neutral
    end
  end

  def appearance
    return "filled outlined"
  end
end
