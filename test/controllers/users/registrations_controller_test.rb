# frozen_string_literal: true

require "test_helper"

class Users::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  include PracticalFramework::SharedTestModules::Controllers::Registrations::NoSelfSignupTests
  include PracticalFramework::SharedTestModules::Controllers::Registrations::NoSelfDestroyTests
  include PracticalFramework::SharedTestModules::Controllers::Registrations::UpdateTests
  include PracticalFramework::TestHelpers::PasskeySystemTestHelpers::RackTest

  def resource_instance
    users.buffy
  end

  def sign_in_as_resource
    sign_in(resource_instance)
  end

  def new_reauthentication_challenge_action
    post new_user_reauthentication_challenge_url
  end

  def reauthenticate_action(params:)
    post user_reauthentication_url, params: params, as: :json
  end

  def new_registration_challenge_action
    post new_user_registration_challenge_url, params: {user: {email: Faker::Internet.email, passkey_label: Faker::Computer.stack}}
  end

  def new_registration_action
    get new_user_registration_url
  end

  def create_registration_action
    post user_registration_url, params: {user: {email: Faker::Internet.email, passkey_label: Faker::Computer.stack}}
  end

  def destroy_registration_action
    delete user_registration_url
  end

  def edit_registration_action
    get edit_user_registration_url
  end

  def params_for_updating_resource(email:, name: Faker::Name.name, reauthentication_token:)
    {user: {email: email, name: name, reauthentication_token: reauthentication_token}}
  end

  def params_trying_to_update_other_resource(email:, reauthentication_token:)
    {user: {email: email, name: name, reauthentication_token: reauthentication_token}, user_id: other_resource.id}
  end

  def update_registration_action(params:)
    patch user_registration_url, params: params
  end

  def other_resource
    users.rosa
  end

  def attempt_to_edit_other_resource_action
    get edit_user_registration_url(other_resource)
  end

  def expected_stored_reauthentication_challenge
    session["user_current_reauthentication_challenge"]
  end

  def expected_relying_party_data
    {"name"=> I18n.translate("app_title.text")}
  end

  def expected_user_data_for_challenge
    user_data(user: resource_instance)
  end

  def webauthn_client
    user_webauthn_client
  end

  def webauthn_relying_party
    relying_party
  end

  def get_reauthentication_token
    session["user_current_reauthentication_token"]
  end

  alias_method :expected_stored_reauthentication_token, :get_reauthentication_token

  def passkey_class
    User::Passkey
  end

  def resource_class
    User
  end

  def expected_update_success_url
    edit_user_registration_url
  end

  def assert_reauthentication_token_challenge
    assert_passkey_authentication_challenge(
      data: response.parsed_body,
      stored_challenge: expected_stored_reauthentication_challenge,
      credentials_to_allow: resource_instance.passkeys
    )
  end

  def assert_not_reauthenticated_message
    expected = {"error" => I18n.translate("devise.passkeys.not_reauthenticated")}
    assert_equal expected, response.parsed_body
  end

  def assert_form_error_for_email(message:)
    assert_error_json_contains(
    container_id: "user_email_errors",
    element_id: "user_email",
    message: message
  )
  end
end

class Users::RegistrationsControllerSelfSignupTest < ActionDispatch::IntegrationTest
  include PracticalFramework::SharedTestModules::Controllers::Registrations::SelfSignupTests
  include PracticalFramework::TestHelpers::PasskeySystemTestHelpers::RackTest

  setup do
    Flipper.enable(:self_service_user_registration)
  end

  def existing_resource
    users.buffy
  end

  def params_for_registration_challenge(email:, passkey_label:)
    {user: {email: email, passkey_label: passkey_label}}
  end

  def params_for_registration(email:, passkey_label:, raw_credential:)
    {user: {email: email, name: Faker::Name.name, passkey_label: passkey_label, passkey_credential: raw_credential.to_json}}
  end

  def new_registration_challenge_action(params:)
    post new_user_registration_challenge_url, params: params
  end

  def create_resource_action(params:)
    post user_registration_url, params: params
  end

  def new_registration_action
    get new_user_registration_url
  end

  def expected_stored_challenge
    session["user_current_webauthn_registration_challenge"]
  end

  def expected_relying_party_data
    {"name"=> I18n.translate("app_title.text")}
  end

  def expected_user_data_for_challenge(email:, webauthn_id:, name:)
    {"name"=>email, "id"=>webauthn_id, "displayName"=>name}
  end

  def assert_email_missing_error_message
    expected = {"message" => I18n.translate("devise.registrations.email_missing")}
    assert_equal expected, response.parsed_body
  end

  def assert_passkey_label_missing_error_message
    expected = {"message" => I18n.translate("devise.registrations.passkey_label_missing")}
    assert_equal expected, response.parsed_body
  end

  def webauthn_client
    user_webauthn_client
  end

  def webauthn_relying_party
    relying_party
  end

  def passkey_class
    User::Passkey
  end

  def resource_class
    User
  end

  def expected_success_url
    root_url
  end
end

class Users::RegistrationsControllerSelfDestroyTest < ActionDispatch::IntegrationTest
  include PracticalFramework::SharedTestModules::Controllers::Registrations::SelfDestroyTests
  include PracticalFramework::TestHelpers::PasskeySystemTestHelpers::RackTest

  setup do
    Flipper.enable(:self_service_user_destruction)
  end

  def resource_instance
    users.buffy
  end

  def other_resource
    users.rosa
  end

  def sign_in_as_resource
    sign_in(resource_instance)
  end

  def new_reauthentication_challenge_action
    post new_user_reauthentication_challenge_url
  end

  def reauthenticate_action(params:)
    post user_reauthentication_url, params: params, as: :json
  end

  def expected_relying_party_data
    {"name"=> I18n.translate("app_title.text")}
  end

  def expected_user_data_for_challenge
    user_data(user: resource_instance)
  end

  def params_for_destruction(reauthentication_token:)
    {user: {reauthentication_token: reauthentication_token}}
  end

  def params_trying_to_destroy_other_resource(reauthentication_token:)
    {id: other_resource.id, user: {reauthentication_token: reauthentication_token}}
  end

  def destroy_registration_action(params:)
    delete user_registration_url, params: params
  end

  def webauthn_client
    user_webauthn_client
  end

  def webauthn_relying_party
    relying_party
  end

  def resource_class
    User
  end

  def destroy_success_url
    root_url
  end

  def assert_reauthentication_token_challenge
    assert_passkey_authentication_challenge(
      data: response.parsed_body,
      stored_challenge: expected_stored_reauthentication_challenge,
      credentials_to_allow: resource_instance.passkeys
    )
  end

  def assert_not_reauthenticated_message
    expected = {"error" => I18n.translate("devise.passkeys.not_reauthenticated")}
    assert_equal expected, response.parsed_body
  end

  def get_reauthentication_token
    session["user_current_reauthentication_token"]
  end

  def expected_stored_reauthentication_challenge
    session["user_current_reauthentication_challenge"]
  end

  alias_method :expected_stored_reauthentication_token, :get_reauthentication_token
end