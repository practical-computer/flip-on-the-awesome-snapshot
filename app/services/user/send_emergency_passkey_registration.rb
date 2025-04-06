# frozen_string_literal: true

class User::SendEmergencyPasskeyRegistration
  attr_accessor :user, :ip_address, :user_agent, :emergency_registration

  def initialize(email:, ip_address:, user_agent:)
    self.user = User.find_by!(email: email)

    if ip_address.present?
      self.ip_address = Utility::IPAddress.upsert_address(address: ip_address)
    end

    if user_agent.present?
      self.user_agent = Utility::UserAgent.upsert_user_agent(user_agent: user_agent)
    end
  end

  def run!
    self.emergency_registration = self.user.emergency_passkey_registrations.create!(
      utility_user_agent: self.user_agent,
      utility_ip_address: self.ip_address,
    )

    User::EmergencyPasskeyRegistrationMailer.emergency_registration_request(
                                              emergency_passkey_registration: emergency_registration
                                            )
                                            .deliver_later
  end
end
