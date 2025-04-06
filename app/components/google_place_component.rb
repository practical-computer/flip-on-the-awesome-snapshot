# frozen_string_literal: true

class GooglePlaceComponent < Phlex::HTML
  attr_accessor :google_place

  def initialize(google_place:)
    self.google_place = google_place
  end

  def view_template
    address(class: "google-place") { google_place.human_address }
  end
end