# frozen_string_literal: true

require "test_helper"
require "practical_framework/test_helpers/postmark_template_helpers"

class Administrator::EmergencyPasskeyRegistrationMailerTest < ActionMailer::TestCase
  include PracticalFramework::TestHelpers::PostmarkTemplateHelpers
  include Rails.application.routes.url_helpers

  test "emergency_registration_request" do
    emergency_registration =  administrators.kira.emergency_passkey_registrations.first

    Timecop.freeze(Time.now.utc) do
      mail = Administrator::EmergencyPasskeyRegistrationMailer.emergency_registration_request(emergency_passkey_registration: emergency_registration)

      assert_equal "Postmark Template: \"administrator-emergency-passkey-registration\"", mail.subject
      assert_equal [emergency_registration.administrator.email], mail.to
      assert_equal [AppSettings.support_email], mail.from


      template_model = extract_template_model(mail: mail)

      token = emergency_registration.generate_token_for(:emergency_registration)

      client = emergency_registration&.utility_user_agent&.client || DeviceDetector.new
      browser_name = [client.name, client.full_version].compact.join(" ")
      operating_system = [client.device_name, client.os_name, client.os_full_version].compact.join(" ")

      assert_equal root_url, template_model["product_url"]
      assert_equal AppSettings.app_name, template_model["product_name"]
      assert_equal "Administrator", template_model["name"]
      assert_equal administrator_emergency_passkey_registration_url(token), template_model["action_url"]
      assert_equal AppSettings.support_url, template_model["support_url"]
      assert_equal AppSettings.company_name, template_model["company_name"]
      assert_equal AppSettings.company_address, template_model["company_address"]

      assert_equal browser_name, template_model["browser_name"]
      assert_equal operating_system, template_model["operating_system"]
    end
  end
end
