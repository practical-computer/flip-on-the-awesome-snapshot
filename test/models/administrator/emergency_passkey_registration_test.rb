# frozen_string_literal: true

require "test_helper"

class Administrator::EmergencyPasskeyRegistrationTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper
  include PracticalFramework::SharedTestModules::Models::EmergencyPasskeyRegistrations::BaseTests
  include PracticalFramework::SharedTestModules::Models::EmergencyPasskeyRegistrations::UseForAndNotifyTests

  def model_class
    Administrator::EmergencyPasskeyRegistration
  end

  def model_instance
    administrators.kira.emergency_passkey_registrations.first
  end

  def owner_reflection_name
    :administrator
  end

  def owner_instance
    administrators.kira
  end

  def expiration_timespan
    20.minutes
  end

  def already_used_error_class
    Administrator::EmergencyPasskeyRegistration::AlreadyUsedError
  end

  def passkey_mailer_class
    Administrator::PasskeyMailer
  end

  def create_passkey_instance
    owner_instance.passkeys.create!(
      label: Faker::Computer.stack,
      external_id: SecureRandom.hex,
      public_key: SecureRandom.hex
    )
  end
end
