# frozen_string_literal: true

class Organization::JobTasksSummaryComponent < ApplicationComponent
  include Organization::JobTask::StatusColorVariant
  attr_accessor :job_tasks

  def initialize(job_tasks:)
    @job_tasks = job_tasks
  end

  def counts
    job_tasks.group(:status).count
  end

  def call
    tag.section(class: "wa-cluster") {
      safe_join(counts.map{|status, count| count_tag(status: status, count: count) })
    }
  end

  def count_tag(status:, count:)
    tag.wa_tag(class: count_tag_classes(status: status)) {
      tag.span(class: "wa-cluster:column"){
        safe_join([
          helpers.icon_text(
            icon: helpers.icon_set.job_task_status_icon(status: status),
            text: helpers.human_job_task_status(status: status),
            options: {class: "wa-gap-xs"}
          ),
          tag.wa_badge(count, pill: true)
        ])
      }
    }
  end

  def count_tag_classes(status:)
    helpers.class_names("job-task-status-badge", color_variant(status: status).to_css)
  end
end
