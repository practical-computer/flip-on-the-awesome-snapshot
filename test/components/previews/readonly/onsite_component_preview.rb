# frozen_string_literal: true

class Readonly::OnsiteComponentPreview < ViewComponent::Preview
  def default
    render(Readonly::OnsiteComponent.new(onsite: "onsite"))
  end
end
