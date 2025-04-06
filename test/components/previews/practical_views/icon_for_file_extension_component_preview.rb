# frozen_string_literal: true

class PracticalViews::IconForFileExtensionComponentPreview < ViewComponent::Preview
  def default
    render(PracticalViews::IconForFileExtensionComponent.new(extension: :pdf))
  end
end
