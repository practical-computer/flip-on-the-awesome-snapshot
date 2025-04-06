# frozen_string_literal: true

require "application_system_test_case"

class User::MembershipInvitationsTest < SlowBrowserSystemTestCase
  test "can register from an invitation" do
    skip_because_old_ui?
    email = Faker::Internet.email
    name = Faker::Name.name
    passkey_label = Faker::Computer.stack

    authenticator = add_virtual_authenticator

    organization = organizations.organization_3

    membership_invitation = organization.membership_invitations.create!(email: email, sender: users.organization_3_owner, membership_type: :staff)
    token = membership_invitation.generate_token_for(:invitation)
    visit membership_invitation_url(token)

    fill_in "Name", with: name
    fill_in "Passkey label", with: passkey_label

    click_button I18n.translate("membership_invitations.new_user_from_invitation_form.submit_button_title")

    assert_current_path new_user_session_url

    assert_toast_message(text: I18n.translate("membership_invitations.registered_message"))

    fill_in "Email", with: email

    click_on "Sign in"

    assert_current_path organization_url(organization)
  end

  test "can accept an invitation when signed in" do
    user = users.invited_user_1
    assert_sign_in_user(user: user)

    name = Faker::Name.name
    passkey_label = Faker::Computer.stack

    authenticator = add_virtual_authenticator

    membership_invitation = MembershipInvitation.find_by!(email: user.email)
    organization = membership_invitation.organization
    token = membership_invitation.generate_token_for(:invitation)
    visit membership_invitation_url(token)

    click_button I18n.translate("membership_invitations.accept_form.accept_as_current_user.accept_button_title")

    assert_current_path organization_url(organization)

    assert_toast_message(text: I18n.translate("membership_invitations.accepted_message", organization_name: organization.name))
  end
end
