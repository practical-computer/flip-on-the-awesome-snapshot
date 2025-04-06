# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/administrator/emergency_passkey_registration_mailer
class Administrator::EmergencyPasskeyRegistrationMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/administrator/emergency_passkey_registration_mailer/emergency_registration_request
  def emergency_registration_request
    administrator = Administrator.find_by(email: "thomas@practical.computer")
    emergency_passkey_registration = administrator.emergency_passkey_registrations.build
    Administrator::EmergencyPasskeyRegistrationMailer.emergency_registration_request(emergency_passkey_registration: emergency_passkey_registration).prerender
  end
end
