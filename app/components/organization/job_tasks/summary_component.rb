# frozen_string_literal: true

class Organization::JobTasks::SummaryComponent < Phlex::HTML
  attr_accessor :job_tasks, :statuses

  def initialize(job_tasks:, statuses: Organization::JobTask.statuses.keys)
    self.job_tasks = job_tasks
    self.statuses = statuses
  end

  def view_template
    section(class: tokens("cluster-compact")) {
      counts.each do |status, count|
        render CountBadge.new(status: status, count: count)
      end
    }
  end

  def counts
    job_tasks.where(status: statuses).group(:status).count
  end

  class CountBadge < Phlex::HTML
    attr_accessor :status, :count

    def initialize(status:, count:)
      self.status = status
      self.count = count
    end

    def view_template
      span(class: tokens("badge labeled-badge compact-size rounded job-task-status-badge", status), title: title) {
        unsafe_raw helpers.job_task_status_icon(status: status)
        whitespace
        plain count
      }
    end

    def title
      helpers.pluralize(count, helpers.human_job_task_status(status: status))
    end
  end
end