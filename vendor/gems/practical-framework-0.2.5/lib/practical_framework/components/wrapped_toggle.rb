# frozen_string_literal: true

module PracticalFramework::Components::WrappedToggle
  def default_label_classes
    ["card", "with-sidebar", "no-max-inline-size", "springed-toggle"]
  end

  def default_toggle_wrapper_classes
    ["toggle-with-icon", "raised-labeling"]
  end

  def view_template(&block)
    label(for: id, class: tokens(default_label_classes), &block)
  end

  def field_label(title:, description:, classes: nil)
    div(class: tokens(['card-label', 'stack-extra-compact', 'flex-basis-auto'] + Array.wrap(classes))) {
      span { title }
      small(class: "description") { description }
    }
  end

  def toggle_wrapper(classes: nil, &block)
    div(class: tokens(default_toggle_wrapper_classes + Array.wrap(classes)), &block)
  end
end
