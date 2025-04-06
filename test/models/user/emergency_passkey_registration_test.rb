# frozen_string_literal: true

require "test_helper"

class User::EmergencyPasskeyRegistrationTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper
  include PracticalFramework::SharedTestModules::Models::EmergencyPasskeyRegistrations::BaseTests
  include PracticalFramework::SharedTestModules::Models::EmergencyPasskeyRegistrations::UseForAndNotifyTests

  def model_class
    User::EmergencyPasskeyRegistration
  end

  def model_instance
    users.rosa.emergency_passkey_registrations.first
  end

  def owner_reflection_name
    :user
  end

  def owner_instance
    users.rosa
  end

  def expiration_timespan
    1.day
  end

  def already_used_error_class
    User::EmergencyPasskeyRegistration::AlreadyUsedError
  end

  def passkey_mailer_class
    User::PasskeyMailer
  end

  def create_passkey_instance
    owner_instance.passkeys.create!(
      label: Faker::Computer.stack,
      external_id: SecureRandom.hex,
      public_key: SecureRandom.hex
    )
  end
end
