# frozen_string_literal: true

require 'postmark-rails/templated_mailer'

class Administrator::EmergencyPasskeyRegistrationMailer < ApplicationMailer
  include PostmarkRails::TemplatedMailerMixin

  def emergency_registration_request(emergency_passkey_registration:)
    token = emergency_passkey_registration.generate_token_for(:emergency_registration)

    client = emergency_passkey_registration&.utility_user_agent&.client || DeviceDetector.new("")

    browser_name = [client.name, client.full_version].compact.join(" ")
    operating_system = [client.device_name, client.os_name, client.os_full_version].compact.join(" ")

    self.template_model = {
      product_url: root_url,
      product_name: AppSettings.app_name,
      name: "Administrator",
      action_url: administrator_emergency_passkey_registration_url(token),
      support_url: AppSettings.support_url,
      company_name: AppSettings.company_name,
      company_address: AppSettings.company_address,
      browser_name: browser_name,
      operating_system: operating_system,
    }

    mail(to: emergency_passkey_registration.administrator.email,
         postmark_template_alias: 'administrator-emergency-passkey-registration'
        )
  end
end
