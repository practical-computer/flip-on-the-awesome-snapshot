# frozen_string_literal: true

class PracticalViews::PageComponentPreview < ViewComponent::Preview
  def default
    render(PracticalViews::PageComponent.new)
  end
end
