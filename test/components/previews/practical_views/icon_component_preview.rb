# frozen_string_literal: true

class PracticalViews::IconComponentPreview < ViewComponent::Preview
  def default
    render(PracticalViews::IconComponent.new(name: :user, family: :solid))
  end

  def duotone
    render(PracticalViews::IconComponent.new(name: :user, family: :duotone, variant: :solid))
  end

  def with_extra_classes
    render(PracticalViews::IconComponent.new(name: :"chevron-down", family: :solid, options: {class: "details-marker"}))
  end

  def with_custom_style
    render(PracticalViews::IconComponent.new(name: :camera, family: :solid, options: {style: "font-size: 3em; color: Tomato;"}))
  end
end
