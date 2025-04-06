# frozen_string_literal: true

class PracticalViews::Navigation::BreadcrumbItemComponent < PracticalViews::BaseComponent
  renders_one :prefix
  attr_accessor :options

  def initialize(options: {})
    self.options = options
  end


  def call
    tag.wa_breadcrumb_item(**mix({}, options)) {
      safe_join([
        (prefix if prefix?),
        content
      ])
    }
  end
end
