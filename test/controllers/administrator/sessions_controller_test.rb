# frozen_string_literal: true

require "test_helper"

class Administrator::SessionsControllerTest < ActionDispatch::IntegrationTest
  include PracticalFramework::SharedTestModules::Controllers::Sessions::BaseTests
  include PracticalFramework::TestHelpers::PasskeySystemTestHelpers::RackTest

  def get_new_session_url
    get new_administrator_session_url
  end

  def issue_new_challenge_action
    post administrator_new_session_challenge_url
  end

  def get_session_challenge
    session["administrator_current_webauthn_authentication_challenge"]
  end

  alias_method :expected_stored_challenge, :get_session_challenge

  def expected_credentials_to_allow
    administrators.kira.passkeys
  end

  def assert_redirected_to_new_session_url
    assert_redirected_to new_administrator_session_url
  end

  def authenticate_action(params:)
    post administrator_session_url, params: params
  end

  def sign_in_as_resource
    sign_in(administrators.kira)
  end

  def resource_key
    :administrator
  end

  def client
    fake_client(origin: admin_relying_party_origin, authenticator: fake_authenticator)
  end

  def assert_resource_not_signed_in
    assert_nil session["warden.user.administrator.key"]
  end

  def assert_resource_signed_in
    assert_equal administrators.kira.id, session["warden.user.administrator.key"][0][0]
  end

  def remember_cookie_value
    cookies["remember_administrator_token"]
  end

  def assert_resource_remembered
    assert_not_nil remember_cookie_value
    assert_not_nil administrators.kira.remember_created_at
  end

  def invalidate_all_credentials
    administrators.kira.passkeys.map{|x| x.update!(external_id: SecureRandom.hex)}
  end

  setup do
    create_passkey_for_administrator_and_return_webauthn_credential(administrator: administrators.kira)
  end
end

class Administrator::SessionsControllerCrossPollinationTest < ActionDispatch::IntegrationTest
  include PracticalFramework::SharedTestModules::Controllers::Sessions::CrossPollinationTests
  include PracticalFramework::TestHelpers::PasskeySystemTestHelpers::RackTest

  def issue_new_challenge_action
    post administrator_new_session_challenge_url
  end

  def get_session_challenge
    session["administrator_current_webauthn_authentication_challenge"]
  end

  alias_method :expected_stored_challenge, :get_session_challenge

  def sign_in_as_other_resource
    sign_in(other_resource, scope: :user)
  end

  def other_resource
    users.buffy
  end

  def client
    fake_client(origin: admin_relying_party_origin, authenticator: fake_authenticator)
  end

  def authenticate_action(params:)
    post administrator_session_url, params: params
  end

  def resource_key
    :administrator
  end

  def assert_resource_not_signed_in
    assert_nil session["warden.user.administrator.key"]
  end

  setup do
    create_passkey_for_administrator_and_return_webauthn_credential(administrator: other_resource)
  end
end