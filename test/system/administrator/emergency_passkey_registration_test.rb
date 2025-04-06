# frozen_string_literal: true

require "application_system_test_case"

class Administrator::EmergencyPasskeyRegistrationsBrowserSelfServiceTest < SlowBrowserSystemTestCase
  setup do
    skip_because_old_ui?
    Flipper.enable(:self_service_administrator_emergency_passkey_registration)
  end

  test "can emergency register a passkey" do
    administrator = administrators.kira
    administrator.emergency_passkey_registrations.delete_all

    authenticator = add_virtual_authenticator

    visit new_administrator_emergency_passkey_registration_url

    fill_in "Email", with: administrator.email

    click_on "Get registration instructions"

    assert_current_path new_administrator_session_url

    assert_toast_message(text: I18n.translate("emergency_passkey_registrations.sent_message"))

    emergency_registration = administrator.emergency_passkey_registrations.reload.first

    token = emergency_registration.generate_token_for(:emergency_registration)

    visit administrator_emergency_passkey_registration_url(token)

    fill_in "Passkey label", with: Faker::Computer.stack

    click_button "Register passkey"

    assert_current_path new_administrator_session_url

    assert_toast_message(text: I18n.translate("emergency_passkey_registrations.registered_message"))

    fill_in "Email", with: administrator.email

    click_on "Sign in"

    assert_current_path admin_root_url
  end
end


class Administrator::EmergencyPasskeyRegistrationsBrowserTest < SlowBrowserSystemTestCase
  test "can emergency register a passkey from a direct link" do
    skip_because_old_ui?
    administrator = administrators.kira
    authenticator = add_virtual_authenticator
    emergency_registration = administrator.emergency_passkey_registrations.reload.first

    token = emergency_registration.generate_token_for(:emergency_registration)

    visit administrator_emergency_passkey_registration_url(token)

    fill_in "Passkey label", with: Faker::Computer.stack

    click_button "Register passkey"

    assert_current_path new_administrator_session_url

    assert_toast_message(text: I18n.translate("emergency_passkey_registrations.registered_message"))

    fill_in "Email", with: administrator.email

    click_on "Sign in"

    assert_current_path admin_root_url
  end
end
