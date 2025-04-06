# frozen_string_literal: true

class Organization::JobTask::Datatable::JobComponent < Organization::JobTask::Datatable::BaseComponent
  attr_accessor :organization_job

  def initialize(organization_job:, datatable_form:, job_tasks:, pagy:, request:)
    super(
      datatable_form: datatable_form,
      job_tasks: job_tasks,
      pagy: pagy,
      request: request,
    )

    self.organization_job = organization_job
  end

  def sort_url_for(key:)
    datatable_params = Navigation::DatatableSortLink.merged_payload(datatable_form: datatable_form,
                                                                    sort_key: key
                                                                   )

    helpers.organization_job_url(current_organization, organization_job, datatable: datatable_params)
  end

  def datatable_form_url
    helpers.organization_job_url(current_organization, organization_job)
  end
end
