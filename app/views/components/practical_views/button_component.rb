# frozen_string_literal: true

class PracticalViews::ButtonComponent < PracticalViews::BaseComponent
  include PracticalViews::Button::Styling
  attr_accessor :type, :appearance, :color_variant, :size, :options

  def initialize(type:, appearance: nil, color_variant: nil, size: nil, options: {})
    @type = type
    @options = options
    initialize_style_utilities(appearance: appearance, color_variant: color_variant, size: size)
  end

  def call
    finalized_options = mix({
      type: type,
      class: css_classes_from_style_utilities
    }, options)

    tag.button(content, **finalized_options)
  end
end
