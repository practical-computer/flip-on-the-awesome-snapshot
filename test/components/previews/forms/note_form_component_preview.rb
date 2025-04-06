# frozen_string_literal: true

class Forms::NoteFormComponentPreview < ViewComponent::Preview
  def default
    render(Forms::NoteFormComponent.new(form: "form"))
  end
end
