# frozen_string_literal: true

class Forms::JobTaskFormComponentPreview < ViewComponent::Preview
  def default
    render(Forms::JobTaskFormComponent.new(form: "form"))
  end
end
