# frozen_string_literal: true

class ApplicationFormBuilder < PracticalFramework::FormBuilders::Base
  def google_places_popover_button(google_place_popover_id:)
    title = @template.t("dispatcher.google_place.address_confirmation_button_title")
    @template.render(
      PracticalFramework::Components::PopoverButton.new(title: title,
                                                        leading_icon: @template.info_icon,
                                                        type: :button,
                                                        html_options: {
                                                          popovertarget: google_place_popover_id,
                                                          disabled: true
                                                        }
                                                      )
    )
  end

  def google_places_autocomplete_field(object_method, location_field_name:, popover_id:)
    if @object.respond_to?(object_method)
      value = @object.public_send(object_method)
    else
      value = nil
    end

    @template.render(
      GooglePlaceAutocompleteComponent.new(popover_id: popover_id,
                                           field_name: field_name(object_method),
                                           google_place: value
                                          ) do
        self.text_field(location_field_name, data: {"autocomplete-element": true},
                                             autocomplete: "none",
                                             value: value&.human_address
                       )
      end
    )
  end
end