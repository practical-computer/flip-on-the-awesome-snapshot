# frozen_string_literal: true

module PracticalViews::Button::Styling
  extend ActiveSupport::Concern

  def initialize_style_utilities(appearance: nil, color_variant: nil, size: nil)
    if appearance.present?
      self.appearance = PracticalViews::WebAwesome::StyleUtility::AppearanceVariant.new(variants: appearance)
    end

    if color_variant.present?
      self.color_variant = PracticalViews::WebAwesome::StyleUtility::ColorVariant.new(variant: color_variant)
    end

    if size.present?
      self.size = PracticalViews::WebAwesome::StyleUtility::Size.new(size: size)
    end
  end

  def css_classes_from_style_utilities
    helpers.class_names([appearance&.to_css, color_variant&.to_css, size&.to_css].compact)
  end
end