# frozen_string_literal: true

class Readonly::TaskTableComponent < ApplicationComponent
  attr_accessor :job_tasks

  def initialize(job_tasks:)
    @job_tasks = job_tasks
  end
end
