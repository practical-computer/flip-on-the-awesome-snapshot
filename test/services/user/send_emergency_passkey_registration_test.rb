# frozen_string_literal: true

require "test_helper"

class User::SendEmergencyPasskeyRegistrationTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  def assert_successful_run(service:)
    assert_difference "User::EmergencyPasskeyRegistration.count", +1 do
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
    User::SendEmergencyPasskeyRegistration
  end

  def mailer_class
    User::EmergencyPasskeyRegistrationMailer
  end

  def valid_email
    users.buffy.email
  end
end
