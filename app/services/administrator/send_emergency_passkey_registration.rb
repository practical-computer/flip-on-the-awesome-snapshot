# frozen_string_literal: true

class Administrator::SendEmergencyPasskeyRegistration
  attr_accessor :administrator, :ip_address, :user_agent, :emergency_registration

  def initialize(email:, ip_address:, user_agent:)
    self.administrator = Administrator.find_by!(email: email)

    if ip_address.present?
      self.ip_address = Utility::IPAddress.upsert_address(address: ip_address)
    end

    if user_agent.present?
      self.user_agent = Utility::UserAgent.upsert_user_agent(user_agent: user_agent)
    end
  end

  def run!
    self.emergency_registration = self.administrator.emergency_passkey_registrations.create!(
      utility_user_agent: self.user_agent,
      utility_ip_address: self.ip_address,
    )

    Administrator::EmergencyPasskeyRegistrationMailer.emergency_registration_request(
                                                        emergency_passkey_registration: emergency_registration
                                                      )
                                                      .deliver_later
  end
end
