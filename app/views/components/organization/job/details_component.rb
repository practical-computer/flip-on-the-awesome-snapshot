# frozen_string_literal: true

class Organization::Job::DetailsComponent < ApplicationComponent
  attr_accessor :job

  delegate :current_organization, to: :helpers

  def initialize(job:)
    @job = job
  end
end
