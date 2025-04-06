# frozen_string_literal: true

class PracticalFramework::Components::CardButton < Phlex::HTML
  def initialize(type: "button", disabled: false, classes: [], html_options: {})
    @button_attributes = html_options.reverse_merge(
      type: type,
      disabled: disabled,
      class: all_button_classes(extra_classes: classes),
    )
  end

  def default_button_classes
    ["card", "with-sidebar", "no-max-inline-size"]
  end

  def all_button_classes(extra_classes:)
    tokens(default_button_classes + Array.wrap(extra_classes))
  end

  def view_template(&block)
    button(**@button_attributes, &block)
  end

  def card_badge(classes: nil, &block)
    div(class: tokens(['card-badge', "embossed", "squircle", "box-compact"] + Array.wrap(classes)), &block)
  end

  def card_label(classes: nil, title:, description:)
    div(class: tokens(['card-label', 'stack-extra-compact'] + Array.wrap(classes))) {
      span { title }
      small(class: "description") { description }
    }
  end
end
