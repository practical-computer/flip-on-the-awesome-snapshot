# frozen_string_literal: true

class PracticalViews::Form::ErrorListComponent < PracticalViews::BaseComponent
  attr_reader :errors

  def initialize(errors:)
    @errors = errors
  end

  def call
    tag.ul(class: 'error-list') {
      safe_join(errors.map{|error| render PracticalViews::Form::ErrorListItemComponent.new(error: error) })
    }
  end
end
