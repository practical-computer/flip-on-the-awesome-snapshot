# frozen_string_literal: true

require "test_helper"

class Users::SessionsControllerTest < ActionDispatch::IntegrationTest
  include PracticalFramework::SharedTestModules::Controllers::Sessions::BaseTests
  include PracticalFramework::TestHelpers::PasskeySystemTestHelpers::RackTest

  def get_new_session_url
    get new_user_session_url
  end

  def issue_new_challenge_action
    post new_user_session_challenge_url
  end

  def get_session_challenge
    session["user_current_webauthn_authentication_challenge"]
  end

  alias_method :expected_stored_challenge, :get_session_challenge

  def expected_credentials_to_allow
    users.buffy.passkeys
  end

  def assert_redirected_to_new_session_url
    assert_redirected_to new_user_session_url
  end

  def authenticate_action(params:)
    post user_session_url, params: params
  end

  def sign_in_as_resource
    sign_in(users.buffy)
  end

  def resource_key
    :user
  end

  def client
    fake_client(origin: relying_party_origin, authenticator: fake_authenticator)
  end

  def assert_resource_not_signed_in
    assert_nil session["warden.user.user.key"]
  end

  def assert_resource_signed_in
    assert_equal users.buffy.id, session["warden.user.user.key"][0][0]
  end

  def remember_cookie_value
    cookies["remember_user_token"]
  end

  def assert_resource_remembered
    assert_not_nil remember_cookie_value
    assert_not_nil users.buffy.remember_created_at
  end

  def invalidate_all_credentials
    users.buffy.passkeys.map{|x| x.update!(external_id: SecureRandom.hex)}
  end

  setup do
    create_passkey_for_user_and_return_webauthn_credential(user: users.buffy)
  end
end

class Users::EmergencySessionsControllerTest < ActionDispatch::IntegrationTest
  test "emergency_login" do
    user = users.organization_1_owner

    get user_emergency_login_url(user.generate_token_for(:emergency_login))

    assert_equal user.id, session["warden.user.user.key"][0][0]
  end
end

class Users::SessionsControllerCrossPollinationTest < ActionDispatch::IntegrationTest
  include PracticalFramework::SharedTestModules::Controllers::Sessions::CrossPollinationTests
  include PracticalFramework::TestHelpers::PasskeySystemTestHelpers::RackTest

  def issue_new_challenge_action
    post new_user_session_challenge_url
  end

  def get_session_challenge
    session["user_current_webauthn_authentication_challenge"]
  end

  alias_method :expected_stored_challenge, :get_session_challenge

  def sign_in_as_other_resource
    sign_in(other_resource, scope: :administrator)
  end

  def other_resource
    administrators.kira
  end

  def resource_key
    :user
  end

  def client
    fake_client(origin: relying_party_origin, authenticator: fake_authenticator)
  end

  def authenticate_action(params:)
    post user_session_url, params: params
  end

  def assert_resource_not_signed_in
    assert_nil session["warden.user.user.key"]
  end

  setup do
    create_passkey_for_user_and_return_webauthn_credential(user: other_resource)
  end
end