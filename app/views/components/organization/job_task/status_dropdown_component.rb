# frozen_string_literal: true

class Organization::JobTask::StatusDropdownComponent < ApplicationComponent
  include Organization::JobTask::StatusColorVariant
  attr_accessor :job_task

  delegate :status, to: :job_task

  def initialize(job_task:)
    @job_task = job_task
  end

  def variant
    color_variant(status: status).to_web_awesome
  end
end
