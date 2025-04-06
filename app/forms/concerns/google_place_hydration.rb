# frozen_string_literal: true

module GooglePlaceHydration
  extend ActiveSupport::Concern

  def hydrate_google_place(value:)
    return nil if value.blank?
    return value if value.is_a?(GooglePlace)

    google_place_json = JSON.parse(value)
    existing_google_place = GooglePlace.find_by(google_place_api_id: google_place_json["place_id"])

    return existing_google_place if existing_google_place.present?

    return GooglePlace.new(google_place_api_id: google_place_json["place_id"],
                           human_address: google_place_json["formatted_address"])
  end
end