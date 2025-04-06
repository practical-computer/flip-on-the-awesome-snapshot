# frozen_string_literal: true

class Organization::Onsite::DetailsComponent < ApplicationComponent
  attr_accessor :onsite

  delegate :current_organization, to: :helpers

  def initialize(onsite:)
    @onsite = onsite
  end
end
