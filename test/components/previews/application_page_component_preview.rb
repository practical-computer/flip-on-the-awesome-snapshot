# frozen_string_literal: true

class ApplicationPageComponentPreview < ViewComponent::Preview
  def default
    render(ApplicationPageComponent.new)
  end
end
