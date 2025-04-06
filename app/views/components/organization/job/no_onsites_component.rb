# frozen_string_literal: true

class Organization::Job::NoOnsitesComponent < ApplicationComponent
  attr_accessor :job

  def initialize(job:)
    self.job = job
  end
end
