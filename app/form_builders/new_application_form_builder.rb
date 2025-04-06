# frozen_string_literal: true

class NewApplicationFormBuilder < PracticalViews::FormBuilders::WebAwesome
  def location_field(object_method:, location_field_name:)
    template.render(Forms::LocationFieldComponent.new(
      f: self,
      object_method: object_method,
      location_field_name: location_field_name
    ))
  end
end