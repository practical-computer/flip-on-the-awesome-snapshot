# frozen_string_literal: true

class PracticalViews::ToastComponentPreview < ViewComponent::Preview
  def default
    render(
      PracticalViews::ToastComponent.new(color_variant: "danger").with_content("An error message")
    )
  end
end
