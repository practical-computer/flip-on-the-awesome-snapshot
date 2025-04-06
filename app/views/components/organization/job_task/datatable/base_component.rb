# frozen_string_literal: true

class Organization::JobTask::Datatable::BaseComponent < ApplicationComponent
  include PracticalViews::Datatable
  attr_accessor :datatable_form, :job_tasks, :pagy, :request

  renders_one :add_job_task_dialog_button

  def initialize(datatable_form:, job_tasks:, pagy:, request:)
    @datatable_form = datatable_form
    @job_tasks = job_tasks
    @pagy = pagy
    @request = request
  end
end
