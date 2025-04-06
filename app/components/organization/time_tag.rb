# frozen_string_literal: true

class Organization::TimeTag < PracticalFramework::Components::TimeTag
  attr_accessor :organization

  def initialize(date_or_time:, organization:)
    super(date_or_time: date_or_time, timezone: organization.timezone)
    self.organization = organization
  end
end