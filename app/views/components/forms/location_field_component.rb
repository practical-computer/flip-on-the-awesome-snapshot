# frozen_string_literal: true

class Forms::LocationFieldComponent < ApplicationComponent
  attr_accessor :f, :object_method, :location_field_name

  def initialize(f:, object_method:, location_field_name:)
    @f = f
    @object_method = object_method
    @location_field_name = location_field_name
  end

  def field_name
    f.field_name(object_method)
  end

  def field_value
    return nil if google_place.blank?
    JSON.generate({formatted_address: google_place.human_address, place_id: google_place.google_place_api_id })
  end

  def google_place
    return nil unless f.object.respond_to?(object_method)
    return f.object.public_send(object_method)
  end

  def location_field_value
    google_place&.human_address
  end
end
