# frozen_string_literal: true

class Forms::OnsiteFormComponentPreview < ViewComponent::Preview
  def default
    render(Forms::OnsiteFormComponent.new(form: "form"))
  end
end
