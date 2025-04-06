# frozen_string_literal: true

class Organization::JobTask::AddDialogComponent < ApplicationComponent
  attr_accessor :form

  def initialize(form:)
    @form = form
  end

  def dialog_id
    dom_id(form, :add_job_task_dialog)
  end
end
