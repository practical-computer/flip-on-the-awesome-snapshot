# frozen_string_literal: true

class Organization::Onsite::TechnicianUrlComponent < ApplicationComponent
  attr_accessor :onsite
  def initialize(onsite:)
    @onsite = onsite
  end
end
