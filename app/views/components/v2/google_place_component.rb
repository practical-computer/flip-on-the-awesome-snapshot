# frozen_string_literal: true

class V2::GooglePlaceComponent < ApplicationComponent
  attr_accessor :google_place

  def initialize(google_place:)
    @google_place = google_place
  end
end
