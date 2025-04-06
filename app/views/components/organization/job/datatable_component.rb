# frozen_string_literal: true

class Organization::Job::DatatableComponent < ApplicationComponent
  include PracticalViews::Datatable
  attr_accessor :datatable_form, :jobs, :pagy, :request

  def initialize(datatable_form:, jobs:, pagy:, request:)
    @datatable_form = datatable_form
    @jobs = jobs
    @pagy = pagy
    @request = request
  end

  def sort_url_for(key:)
    datatable_params = Navigation::DatatableSortLink.merged_payload(datatable_form: datatable_form,
                                                                    sort_key: key
                                                                   )

    helpers.organization_jobs_url(helpers.current_organization, datatable: datatable_params)
  end

  def datatable_form_url
    helpers.organization_jobs_url(helpers.current_organization)
  end
end
