# frozen_string_literal: true

class PracticalFramework::Components::TimeTag < Phlex::HTML
  include Phlex::Rails::Helpers::TimeTag
  attr_accessor :date_or_time, :timezone

  def initialize(date_or_time:, timezone:)
    self.date_or_time = date_or_time
    self.timezone = timezone
  end

  def view_template
    time_tag(date_or_time, title: date_or_time.to_formatted_s(:iso8601)) do
      date_or_time.in_time_zone(timezone).to_formatted_s(:long)
    end
  end
end