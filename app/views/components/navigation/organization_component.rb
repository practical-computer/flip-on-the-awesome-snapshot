# frozen_string_literal: true

class Navigation::OrganizationComponent < ApplicationComponent
  attr_accessor :organization

  def initialize(organization:)
    @organization = organization
  end
end
