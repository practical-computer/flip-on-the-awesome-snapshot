# frozen_string_literal: true

class Organization::Onsite::NoTasksComponent < ApplicationComponent
  attr_accessor :job_task_form

  def initialize(job_task_form:)
    @job_task_form = job_task_form
  end
end
