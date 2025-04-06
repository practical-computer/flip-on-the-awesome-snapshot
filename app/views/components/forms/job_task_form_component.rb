# frozen_string_literal: true

class Forms::JobTaskFormComponent < ApplicationComponent
  attr_accessor :form
  delegate :current_organization, to: :helpers

  def initialize(form:)
    @form = form
  end

  def form_url
    if form.persisted?
      return helpers.job_task_url(current_organization, form.job_task)
    else
      return helpers.organization_job_tasks_url(current_organization, form.job)
    end
  end
end
