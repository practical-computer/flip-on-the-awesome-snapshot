# frozen_string_literal: true

class PracticalViews::WebAwesome::StyleUtility::Base
  include PracticalViews::ElementHelper
  def to_web_awesome
    raise NotImplementedError
  end

  def to_css
    raise NotImplementedError
  end

  def self.css(**options)
    self.new(**options).to_css
  end

  def self.apply_css_prefix(value)
    return value if value.start_with?("wa-")
    "wa-#{value}"
  end
end