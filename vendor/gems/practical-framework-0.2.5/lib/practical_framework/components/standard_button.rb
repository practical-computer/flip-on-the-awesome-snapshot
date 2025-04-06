# frozen_string_literal: true

class PracticalFramework::Components::StandardButton < Phlex::HTML
  attr_reader :title, :leading_icon
  def initialize(type: "button", disabled: false, title:, leading_icon:, classes: [], html_options: {})
    @button_attributes = html_options.reverse_merge(
      type: type,
      disabled: disabled,
      class: all_button_classes(extra_classes: classes),
    )
    @title = title
    @leading_icon = leading_icon
  end

  def default_button_classes
    ["rounded", "raised", "raised-labeling"]
  end

  def all_button_classes(extra_classes:)
    tokens(default_button_classes + Array.wrap(extra_classes))
  end

  def view_template
    button(**@button_attributes){
      unsafe_raw(leading_icon)
      span{ title}
    }
  end
end
