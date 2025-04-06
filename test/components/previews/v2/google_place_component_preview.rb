# frozen_string_literal: true

class V2::GooglePlaceComponentPreview < ViewComponent::Preview
  def default
    render(V2::GooglePlaceComponent.new(google_place: GooglePlace.first))
  end
end
