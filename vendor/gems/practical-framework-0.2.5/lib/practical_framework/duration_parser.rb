# frozen_string_literal: true

class PracticalFramework::DurationParser
  def self.to_minutes(duration:)
    return nil if duration.blank?
    return duration if duration.is_a?(Numeric)
    string_parts = duration.split(":")
    minutes = 0
    hours = 0

    if string_parts.size == 1
      minutes = Integer(string_parts.first)
    else
      if string_parts[0].blank?
        hours = 0
      else
        hours = Integer(string_parts[0])
      end

      if string_parts[1].blank?
        minutes = 0
      else
        minutes = Integer(string_parts[1])
      end
    end

    return (minutes) + (hours * 60)
  rescue ArgumentError
    return nil
  end
end