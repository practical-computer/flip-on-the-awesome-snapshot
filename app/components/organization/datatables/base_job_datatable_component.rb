# frozen_string_literal: true

class Organization::Datatables::BaseJobDatatableComponent < Phlex::HTML
  attr_accessor :datatable_form, :jobs, :pagy, :request, :section_classes

  def initialize(datatable_form:, jobs:, pagy:, request:, extra_section_classes: nil)
    self.datatable_form = datatable_form
    self.jobs = jobs
    self.pagy = pagy
    self.request = request
    self.section_classes = extra_section_classes
  end

  def view_template
    section(class: final_section_classes) {
      render_datatable_form
      if jobs.any?
        render_table
      end
      pagination
    }
  end

  def render_datatable_form
    render partial: "organizations/jobs/datatable_form", locals: {
      datatable_form: datatable_form, url: datatable_form_url
    }
  end

  def render_table
    table(**classes("no-max-inline-size", "jobs")) {
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
          sort_link_for(key: "name") {
            unsafe_raw(helpers.job_name_icon)
            plain("Name")
          }
        }

        th(class: "table-label", scope: "col") {
          sort_link_for(key: "status") {
            unsafe_raw(helpers.status_icon)
            plain("Status")
          }
        }

        th(class: "table-label", scope: "col") {
          unsafe_raw(helpers.job_task_icon)
          plain("Tasks")
        }

        th(class: "table-label", scope: "col") {
          unsafe_raw(helpers.onsite_icon)
          plain("Onsites")
        }
      }
    }
  end

  def table_body
    render(partial: "organizations/jobs/job_table_row",
           collection: jobs,
           as: :job,
           cached: ->(job){ [job.cache_key, job.tasks_and_onsites_updated_at] }
    )
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