# frozen_string_literal: true

class Forms::EmergencyPasskeyRegistration::RegistrationFormComponentPreview < ViewComponent::Preview
  def default
    render(Forms::EmergencyPasskeyRegistration::RegistrationFormComponent.new(form: "form", url: "url", emergency_registration_class: "emergency_registration_class", challenge_url: "challenge_url"))
  end
end
