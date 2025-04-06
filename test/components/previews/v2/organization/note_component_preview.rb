# frozen_string_literal: true

class V2::Organization::NoteComponentPreview < ViewComponent::Preview
  def default
    render(V2::Organization::NoteComponent.new(note: Organization::Note.first))
  end
end
