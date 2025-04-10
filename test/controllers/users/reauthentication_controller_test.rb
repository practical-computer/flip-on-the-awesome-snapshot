# frozen_string_literal: true

require "test_helper"

class Users::ReauthenticationControllerTest < ActionDispatch::IntegrationTest
  include PracticalFramework::SharedTestModules::Controllers::Reauthentication::BaseTests
  include PracticalFramework::SharedTestModules::Controllers::Reauthentication::CrossPollinationTests
  include PracticalFramework::TestHelpers::PasskeySystemTestHelpers::RackTest

  def issue_new_challenge_action
    post new_user_reauthentication_challenge_url
  end

  def get_session_challenge
    session["user_current_reauthentication_challenge"]
  end

  alias_method :expected_stored_challenge, :get_session_challenge

  def get_reauthentication_token
    session["user_current_reauthentication_token"]
  end

  alias_method :expected_stored_reauthentication_token, :get_reauthentication_token

  def expected_credentials_to_allow
    users.buffy.passkeys
  end

  def assert_redirected_to_new_session_url
    assert_redirected_to new_user_session_url
  end

  def reauthenticate_action(params:)
    post user_reauthentication_url, params: params, as: :json
  end

  def sign_in_as_resource
    sign_in(users.buffy)
  end

  def sign_in_as_other_resource
    sign_in(administrators.kira, scope: :administrator)
  end

  def client
    fake_client(origin: relying_party_origin, authenticator: fake_authenticator)
  end

  def assert_resource_not_signed_in
    assert_nil session["warden.user.user.key"]
  end

  def invalidate_all_credentials
    users.buffy.passkeys.map{|x| x.update!(external_id: SecureRandom.hex)}
  end

  setup do
    create_passkey_for_user_and_return_webauthn_credential(user: users.buffy)
  end
end