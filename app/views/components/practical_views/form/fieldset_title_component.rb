# frozen_string_literal: true

class PracticalViews::Form::FieldsetTitleComponent < PracticalViews::BaseComponent
  attr_accessor :options
  renders_one :icon

  def initialize(options: {})
    self.options = options
  end

  def call
    tag.span(**mix({}, options)) {
      safe_join([
        (icon if icon?),
        " ",
        tag.span{ content }
      ])
    }
  end
end
