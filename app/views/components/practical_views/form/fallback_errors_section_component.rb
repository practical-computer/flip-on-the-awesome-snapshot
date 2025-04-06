# frozen_string_literal: true

class PracticalViews::Form::FallbackErrorsSectionComponent < PracticalViews::BaseComponent
  attr_reader :f, :blurb
  def initialize(f:, blurb:, options:)
    @f = f
    @blurb = blurb
    @options = options
  end

  def finalized_options
    mix({
      class: ["error-section", "fallback-error-section", "wa-callout", "wa-danger"]
    }, @options)
  end

  def remaining_errors
    return [] if f.object.errors.blank?
    return f.object.errors.reject{|error| error.options[:has_been_rendered] }
  end
end
