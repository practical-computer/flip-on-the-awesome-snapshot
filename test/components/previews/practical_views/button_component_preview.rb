# frozen_string_literal: true

class PracticalViews::ButtonComponentPreview < ViewComponent::Preview
  def default
    render(PracticalViews::ButtonComponent.new(type: :button).with_content("Hello"))
  end

  def success_color
    render(PracticalViews::ButtonComponent.new(type: :button, color_variant: :success).with_content("Hello"))
  end

  def large_success
    render(PracticalViews::ButtonComponent.new(type: :button, color_variant: :success, size: :large).with_content("Hello"))
  end

  def custom_classes_without_styling
    render(PracticalViews::ButtonComponent.new(type: :button, options: {class: ["class-1", "class-2"]}).with_content("Hello"))
  end

  def custom_classes_with_styling
    render(PracticalViews::ButtonComponent.new(type: :button, color_variant: :success, options: {class: ["class-1", "class-2"]}).with_content("Hello"))
  end
end
