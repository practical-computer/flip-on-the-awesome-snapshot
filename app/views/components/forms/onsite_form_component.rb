# frozen_string_literal: true

class Forms::OnsiteFormComponent < ApplicationComponent
  attr_accessor :form

  def initialize(form:)
    @form = form
  end

  def form_url
    if form.onsite.persisted?
      return helpers.onsite_url(current_organization, form.onsite)
    else
      return helpers.organization_job_onsites_url(current_organization, form.job)
    end
  end
end
