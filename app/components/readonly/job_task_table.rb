# frozen_string_literal: true

class Readonly::JobTaskTable < Phlex::HTML
  attr_accessor :job_tasks, :section_classes

  def initialize(job_tasks:, extra_section_classes: nil)
    self.job_tasks = job_tasks
    self.section_classes = extra_section_classes
  end

  def view_template
    section(class: final_section_classes) {
      if job_tasks.any?
        render_table
      end
    }
  end

  def render_table
    table(**classes("no-max-inline-size", "job_tasks")) {
      col(class: "table-label")
      col(span: 3)
      table_head
      table_body
    }
  end

  def table_head
    thead {
      tr {
        th(class: "table-label", scope: "col") {
          unsafe_raw(helpers.status_icon)
          plain("Status")
        }

        th(class: "table-label", scope: "col") {
          unsafe_raw(helpers.job_task_label_icon)
          plain("Task")
        }

        th(class: "table-label", scope: "col") {
          unsafe_raw(helpers.estimated_duration_icon)
          plain("Estimate")
        }
      }
    }
  end

  def table_body
    render partial: "readonly/onsites/job_task_table_row", collection: job_tasks, as: :job_task
  end

  def final_section_classes
    tokens(["stack-compact"] + Array.wrap(@section_classes))
  end
end