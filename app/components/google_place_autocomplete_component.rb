# frozen_string_literal: true

class GooglePlaceAutocompleteComponent < Phlex::HTML
  attr_accessor :popover_id, :field_name, :google_place

  register_element :google_place_autocomplete
  register_element :anchored_popover

  def initialize(popover_id:, field_name:, google_place:)
    self.popover_id = popover_id
    self.field_name = field_name
    self.google_place = google_place
  end

  def view_template
    google_place_autocomplete(class: "stack-extra-compact", name: field_name, value: field_value) {
      yield if block_given?
      anchored_popover("id": popover_id, "popover": true, "placement": :top, "address-confirmation-popover": true) {
        div(data: {arrow: true})
        section(data: {"popover-content": true},
                class: tokens("rounded box-compact stack-compact compact-size compact-font")) {
          p {
            slot(name: :formatted_address)
          }
        }
      }
    }
  end

  def field_value
    if google_place.present?
      JSON.generate({formatted_address: google_place.human_address, place_id: google_place.google_place_api_id })
    else
      return nil
    end
  end
end