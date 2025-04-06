# frozen_string_literal: true

class PracticalViews::Form::FieldTitleComponentPreview < ViewComponent::Preview
  def default
  end

  def no_icon
    render(PracticalViews::Form::FieldTitleComponent.new.with_content("No icon"))
  end
end
