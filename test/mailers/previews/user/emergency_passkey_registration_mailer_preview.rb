# frozen_string_literal: true

require 'faker'

# Preview all emails at http://localhost:3000/rails/mailers/emergency_passkey_registration_mailer
class User::EmergencyPasskeyRegistrationMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/emergency_passkey_registration_mailer/emergency_registration_request
  def emergency_registration_request
    user = User.new(name: Faker::Name.name, email: Faker::Internet.email)
    emergency_passkey_registration = User::EmergencyPasskeyRegistration.new(
      user: user,
      utility_user_agent: Utility::UserAgent.new(user_agent: Faker::Internet.user_agent),
      utility_ip_address: Utility::IPAddress.new(address: Faker::Internet.ip_v6_address),
    )
    User::EmergencyPasskeyRegistrationMailer.emergency_registration_request(emergency_passkey_registration: emergency_passkey_registration).prerender
  end
end
