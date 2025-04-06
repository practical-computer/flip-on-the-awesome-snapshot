# frozen_string_literal: true

class Readonly::OnsiteComponent < ApplicationComponent
  attr_accessor :onsite

  delegate :job, to: :onsite

  def initialize(onsite:)
    @onsite = onsite
  end

  def google_place
    onsite.google_place.presence || job.google_place.presence
  end
end
