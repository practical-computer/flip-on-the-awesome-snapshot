# frozen_string_literal: true

require "test_helper"

class Administrator::SendEmergencyPasskeyRegistrationTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  def assert_successful_run(service:)
    assert_difference "Administrator::EmergencyPasskeyRegistration.count", +1 do
      service.run!
    end
    assert_enqueued_email_with(
      mailer_class,
      :emergency_registration_request,
      args: [{ emergency_passkey_registration: service.emergency_registration }]
    )
  end

  include PracticalFramework::SharedTestModules::Services::SendEmergencyPasskeyRegistration::BaseTests

  def service_class
    Administrator::SendEmergencyPasskeyRegistration
  end

  def mailer_class
    Administrator::EmergencyPasskeyRegistrationMailer
  end

  def valid_email
    administrators.kira.email
  end
end
