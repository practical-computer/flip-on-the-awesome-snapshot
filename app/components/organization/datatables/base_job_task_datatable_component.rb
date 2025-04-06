# frozen_string_literal: true

class Organization::Datatables::BaseJobTaskDatatableComponent < Phlex::HTML
  attr_accessor :datatable_form, :job_tasks, :pagy, :request, :section_classes

  def initialize(datatable_form:, job_tasks:, pagy:, request:, extra_section_classes: nil)
    self.datatable_form = datatable_form
    self.job_tasks = job_tasks
    self.pagy = pagy
    self.request = request
    self.section_classes = extra_section_classes
  end

  def view_template
    section(class: final_section_classes) {
      render_datatable_form
      if job_tasks.any?
        render_table
      end
      pagination
    }
  end

  def render_datatable_form
    render partial: "organizations/job_tasks/datatable_form", locals: {
      datatable_form: datatable_form, url: datatable_form_url
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
          sort_link_for(key: "status") {
            unsafe_raw(helpers.status_icon)
            plain("Status")
          }
        }

        th(class: "table-label", scope: "col") {
          sort_link_for(key: "label") {
            unsafe_raw(helpers.job_task_label_icon)
            plain("Task")
          }
        }

        th(class: "table-label", scope: "col") {
          sort_link_for(key: "estimated_minutes") {
            unsafe_raw(helpers.estimated_duration_icon)
            plain("Estimate")
          }
        }

        th(class: "table-label", scope: "col") {
          sort_link_for(key: "onsite_label") {
            unsafe_raw(helpers.onsite_icon)
            plain("Onsite")
          }
        }

        th(class: "table-label", scope: "col")
      }
    }
  end

  def table_body
    render partial: "organizations/job_tasks/job_task_table_row", collection: job_tasks, as: :job_task
  end

  def pagination
    render PracticalFramework::Components::Pagination.new(pagy: pagy, request: request, i18n_key: "pagy.item_name")
  end

  def sort_link_for(key:, &block)
    render Navigation::DatatableSortLink.new(
      url: sort_url_for(key: key),
      datatable_form: datatable_form,
      sort_key: key,
      &block
    )
  end

  def sort_url_for(key:)
    raise NotImplementedError
  end

  def datatable_form_url
    raise NotImplementedError
  end

  def final_section_classes
    tokens(["stack-compact"] + Array.wrap(@section_classes))
  end
end