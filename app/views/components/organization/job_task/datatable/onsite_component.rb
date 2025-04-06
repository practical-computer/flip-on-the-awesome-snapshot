# frozen_string_literal: true

class Organization::JobTask::Datatable::OnsiteComponent < Organization::JobTask::Datatable::BaseComponent
  attr_accessor :onsite

  def initialize(onsite:, datatable_form:, job_tasks:, pagy:, request:)
    super(
      datatable_form: datatable_form,
      job_tasks: job_tasks,
      pagy: pagy,
      request: request,
    )

    self.onsite = onsite
  end

  def sort_url_for(key:)
    datatable_params = Navigation::DatatableSortLink.merged_payload(datatable_form: datatable_form,
                                                                    sort_key: key
                                                                   )

    helpers.onsite_url(current_organization, onsite, datatable: datatable_params)
  end

  def datatable_form_url
    helpers.onsite_url(current_organization, onsite)
  end
end
