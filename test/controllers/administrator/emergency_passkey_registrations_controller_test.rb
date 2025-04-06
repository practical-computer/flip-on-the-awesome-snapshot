# frozen_string_literal: true

require "test_helper"

class Administrator::EmergencyPasskeyRegistrationsControllerFlipperSelfServiceTest < ActionDispatch::IntegrationTest
  include PracticalFramework::TestHelpers::AdministratorTestHelpers
  include ActionMailer::TestHelper
  include PracticalFramework::SharedTestModules::Controllers::EmergencyPasskeyRegistrations::SelfServiceTests

  setup do
    switch_to_admin_host
    Flipper.enable(:self_service_administrator_emergency_passkey_registration)
  end

  def owner_instance
    administrators.kira
  end

  def get_new_registration_action(**options)
    get new_administrator_emergency_passkey_registration_url, **options
  end

  def request_emergency_registration_action(**options)
    post administrator_emergency_passkey_registrations_url, **options
  end

  def expected_new_session_url
    new_administrator_session_url
  end

  def send_registration_service_class
    Administrator::SendEmergencyPasskeyRegistration
  end
end

class Administrator::EmergencyPasskeyRegistrationsControllerTest < ActionDispatch::IntegrationTest
  include PracticalFramework::TestHelpers::AdministratorTestHelpers
  include ActionMailer::TestHelper
  include PracticalFramework::SharedTestModules::Controllers::EmergencyPasskeyRegistrations::BaseTests
  include PracticalFramework::SharedTestModules::Controllers::EmergencyPasskeyRegistrations::CrossPollinationTests

  setup do
    switch_to_admin_host
    assert_equal false, Flipper.enabled?(:self_service_administrator_emergency_passkey_registration)
  end

  test "new: returns not_implemented since the feature is not enabled" do
    get_new_registration_action
    assert_response :not_implemented
  end

  test "create: raises RoutingError since the feature is not enabled" do
    request_emergency_registration_action
    assert_response :not_implemented
  end

  def owner_instance
    administrators.kira
  end

  def get_new_registration_action(**options)
    get new_administrator_emergency_passkey_registration_url, **options
  end

  def request_emergency_registration_action(**options)
    post administrator_emergency_passkey_registrations_url, **options
  end

  def expected_new_session_url
    new_administrator_session_url
  end

  def send_registration_service_class
    Administrator::SendEmergencyPasskeyRegistration
  end

  def valid_emergency_registration
    administrators.kira.emergency_passkey_registrations.first
  end

  def valid_emergency_registration_token
    valid_emergency_registration.generate_token_for(:emergency_registration)
  end

  def expired_emergency_registration_token
    token = nil
    Timecop.freeze(1.month.ago) do
      token = valid_emergency_registration.generate_token_for(:emergency_registration)
    end

    return token
  end

  def raw_emergency_registration_id
    valid_emergency_registration.id
  end

  def valid_emergency_registration_token_for_other_resource
    users.rosa.emergency_passkey_registrations.first.generate_token_for(:emergency_registration)
  end

  def show_emergency_registration_action(token:)
    get administrator_emergency_passkey_registration_url(token)
  end

  def get_new_challenge_action(token:)
    post new_challenge_administrator_emergency_passkey_registration_url(token), as: :json
  end

  def expected_stored_challenge
    session["administrator_emergency_passkey_creation_challenge"]
  end

  def expected_relying_party_data
    {"name"=> I18n.translate("administrator.app_title.text")}
  end

  def expected_user_data_for_challenge
    administrator_user_data(administrator: administrators.kira)
  end

  def expected_credentials_to_exclude
    administrators.kira.passkeys.map{|x| credential_data_for_passkey(passkey: x) }
  end

  def webauthn_client
    fake_client(origin: admin_relying_party_origin)
  end

  def params_for_using_emergency_passkey_registration(label:, raw_credential:)
    {
      administrator_emergency_passkey_registration_form: {
        passkey_credential: JSON.generate(raw_credential),
        passkey_label: label
      }
    }
  end

  def params_that_try_to_override_owner_during_emergency_registration(label:, raw_credential:)
    {
      administrator_emergency_passkey_registration_form: {
        passkey_credential: JSON.generate(raw_credential),
        passkey_label: label,
        administrator_id: administrators.thomas.id
      }
    }
  end

  def assert_old_owner_owns_passkey(passkey:)
    assert_equal owner_instance, passkey.administrator
  end

  def passkey_class
    Administrator::Passkey
  end

  def webauthn_relying_party
    admin_relying_party
  end

  def use_emergency_registration_action(token:, params:)
    patch use_administrator_emergency_passkey_registration_url(id: token), params: params
  end

  def assert_form_error_for_credential(message:)
    assert_error_json_contains(
      container_id: "administrator_emergency_passkey_registration_form_passkey_credential_errors",
      element_id: "administrator_emergency_passkey_registration_form_passkey_credential",
      message: message
    )
  end

  def assert_form_error_for_label(message:)
    assert_error_json_contains(
      container_id: "administrator_emergency_passkey_registration_form_passkey_label_errors",
      element_id: "administrator_emergency_passkey_registration_form_passkey_label",
      message: message
    )
  end
end
