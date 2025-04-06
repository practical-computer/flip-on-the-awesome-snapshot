# frozen_string_literal: true

require "test_helper"

class User::EmergencyPasskeyRegistrationFormTest < ActiveSupport::TestCase
  include PracticalFramework::SharedTestModules::Forms::EmergencyPasskeyRegistration::BaseTests
  include ActionMailer::TestHelper

  def passkey_class
    User::Passkey
  end

  def already_used_error_class
    User::EmergencyPasskeyRegistration::AlreadyUsedError
  end

  def assert_new_passkey_email(new_passkey:)
    assert_enqueued_email_with(
      User::PasskeyMailer,
      :passkey_added,
      args: [{ passkey: new_passkey }]
    )
  end

  def valid_form_instance
    emergency_registration = users.rosa.emergency_passkey_registrations.first
    User::EmergencyPasskeyRegistrationForm.new(
      emergency_registration: emergency_registration,
      passkey_label: SecureRandom.hex,
      webauthn_credential: dummy_webauthn_credential,
    )
  end

  def form_instance_with_emergency_registration_that_has_passkey
    form = valid_form_instance
    form.emergency_registration.update!(passkey: User::Passkey.first)
    assert_not_nil form.emergency_registration.passkey
    form
  end

  def form_instance_with_emergency_registration_with_used_at
    form = valid_form_instance
    form.emergency_registration.update!(used_at: Time.now.utc)
    assert_not_nil form.emergency_registration.used_at
    form
  end

  def form_instance_with_no_passkey_label_or_public_key
    emergency_registration = users.rosa.emergency_passkey_registrations.first
    credential = dummy_webauthn_credential
    credential.public_key =  "     "

    User::EmergencyPasskeyRegistrationForm.new(
      emergency_registration: emergency_registration,
      webauthn_credential: credential
    )
  end
end
