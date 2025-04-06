# frozen_string_literal: true

module FormWithHelper
  def webawesome_form_with(**options, &block)
    finalized_options = options.with_defaults(
      builder: NewApplicationFormBuilder
    )
    practical_form_with(**finalized_options, &block)
  end
end
