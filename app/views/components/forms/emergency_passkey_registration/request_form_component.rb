# frozen_string_literal: true

class Forms::EmergencyPasskeyRegistration::RequestFormComponent < ApplicationComponent
  attr_accessor :form, :url, :emergency_registration_class

  def initialize(form:, url:, emergency_registration_class:)
    @form = form
    @url = url
    @emergency_registration_class = emergency_registration_class
  end

  def generic_errors_id
    helpers.dom_id(form, :generic_errors)
  end

  def form_wrapper(&block)
    helpers.webawesome_form_with(
      model: form,
      url: url,
      local: false,
      html: {
        "aria-describedby": generic_errors_id,
      },
      data: {
        type: :json
      },
      &block
    )
  end
end
