# frozen_string_literal: true

class Organization::Onsite::NotesComponentPreview < ViewComponent::Preview
  def default
    render(Organization::Onsite::NotesComponent.new(onsite: "onsite"))
  end
end
