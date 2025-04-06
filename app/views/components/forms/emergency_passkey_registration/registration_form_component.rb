# frozen_string_literal: true

class Forms::EmergencyPasskeyRegistration::RegistrationFormComponent < ApplicationComponent
  attr_accessor :form, :url, :challenge_url

  def initialize(form:, url:, challenge_url:)
    @form = form
    @url = url
    @challenge_url = challenge_url
  end

  def generic_errors_id
    helpers.dom_id(form, :generic_errors)
  end

  def form_wrapper(&block)
    helpers.webawesome_form_with(
      model: form,
      url: url,
      method: :patch,
      local: false,
      html: {
        "aria-describedby": generic_errors_id,
      },
      data: {
        type: :json,
        challenge_url: challenge_url,
        credential_field_name: field_name(form.model_name.param_key, :passkey_credential),
        register_passkey_form: true
      },
      &block
    )
  end
end
