# frozen_string_literal: true

class PracticalViews::Form::ErrorListItemTemplateComponentPreview < ViewComponent::Preview
  def default
    render(PracticalViews::Form::ErrorListItemTemplateComponent.new)
  end
end
