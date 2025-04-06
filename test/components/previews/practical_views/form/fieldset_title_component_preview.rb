# frozen_string_literal: true

class PracticalViews::Form::FieldsetTitleComponentPreview < ViewComponent::Preview
  def default
    render(PracticalViews::Form::FieldsetTitleComponent.new)
  end
end
