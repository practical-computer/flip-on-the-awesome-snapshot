# frozen_string_literal: true

class Organization::Note::ResourceLinkComponentPreview < ViewComponent::Preview
  def default
    render(Organization::Note::ResourceLinkComponent.new(note: "note"))
  end
end
