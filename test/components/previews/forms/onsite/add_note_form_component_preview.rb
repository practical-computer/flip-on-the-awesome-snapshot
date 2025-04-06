# frozen_string_literal: true

class Forms::Onsite::AddNoteFormComponentPreview < ViewComponent::Preview
  def default
    render(Forms::Onsite::AddNoteFormComponent.new(form: "form"))
  end
end
