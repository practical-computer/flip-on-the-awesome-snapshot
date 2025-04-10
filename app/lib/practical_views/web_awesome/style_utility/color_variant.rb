# frozen_string_literal: true

class PracticalViews::WebAwesome::StyleUtility::ColorVariant < PracticalViews::WebAwesome::StyleUtility::Base
  attr_accessor :variant

  def initialize(variant:)
    self.variant = variant.to_s
  end

  def to_web_awesome
    variant
  end

  def to_css
    self.class.apply_css_prefix(variant)
  end
end