# frozen_string_literal: true

class Organization::JobStatusBadge < Phlex::HTML
  attr_accessor :job

  def initialize(job:)
    self.job = job
  end

  def view_template
    span(class: tokens("badge labeled-badge compact-size rounded job-status-badge", job.status), title: title) {
      unsafe_raw helpers.job_status_icon(status: job.status)
      whitespace
      plain title
    }
  end

  def title
    helpers.human_job_status(status: job.status)
  end
end