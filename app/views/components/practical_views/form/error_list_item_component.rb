# frozen_string_literal: true

class PracticalViews::Form::ErrorListItemComponent < PracticalViews::BaseComponent
  attr_reader :error

  def initialize(error:)
    @error = error
  end

  def before_render
    error.options[:has_been_rendered] = true
  end

  def call
    tag.li(class: 'wa-flank', data: {"error-type": error.type}) {
      render(helpers.icon_set.error_list_icon) +
      tag.span(error.message)
    }
  end
end
