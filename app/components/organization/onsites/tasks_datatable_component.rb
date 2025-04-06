# frozen_string_literal: true

class Organization::Onsites::TasksDatatableComponent < Organization::Datatables::BaseJobTaskDatatableComponent
  attr_accessor :organization_onsite

  def initialize(organization_onsite:, datatable_form:, job_tasks:, pagy:, request:)
    super(datatable_form: datatable_form,
          job_tasks: job_tasks,
          pagy: pagy,
          request: request,
          extra_section_classes: "all-tasks"
        )

    self.organization_onsite = organization_onsite
  end

  def sort_url_for(key:)
    datatable_params = Navigation::DatatableSortLink.merged_payload(datatable_form: datatable_form,
                                                                    sort_key: key
                                                                   )

    helpers.onsite_url(helpers.current_organization, self.organization_onsite, datatable: datatable_params)
  end

  def datatable_form_url
    helpers.onsite_url(helpers.current_organization, self.organization_onsite)
  end
end