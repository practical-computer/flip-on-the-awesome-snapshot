# frozen_string_literal: true

class Readonly::JobTaskStatusBadge < Phlex::HTML
  attr_accessor :job_task

  def initialize(job_task:)
    self.job_task = job_task
  end

  def view_template
    span(class: classes, title: title) {
      unsafe_raw helpers.job_task_status_icon(status: job_task.status)
      whitespace
      plain title
    }
  end

  def classes
    tokens("badge labeled-badge compact-size rounded job-task-status-badge", job_task.status)
  end

  def title
    helpers.human_job_task_status(status: job_task.status)
  end
end