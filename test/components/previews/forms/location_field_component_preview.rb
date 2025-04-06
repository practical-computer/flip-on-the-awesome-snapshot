# frozen_string_literal: true

class Forms::LocationFieldComponentPreview < ViewComponent::Preview
  def default
    render(Forms::LocationFieldComponent.new(f: "f", object_method: "object_method", location_field_name: "location_field_name"))
  end
end
