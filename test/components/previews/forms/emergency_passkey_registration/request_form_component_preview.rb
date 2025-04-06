# frozen_string_literal: true

class Forms::EmergencyPasskeyRegistration::RequestFormComponentPreview < ViewComponent::Preview
  def default
    render(Forms::EmergencyPasskeyRegistration::RequestFormComponent.new(form: "form", url: "url", emergency_registration_class: "emergency_registration_class"))
  end
end
