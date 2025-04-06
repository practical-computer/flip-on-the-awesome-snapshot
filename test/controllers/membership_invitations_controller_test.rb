# frozen_string_literal: true

require "test_helper"

class MembershipInvitationsControllerTest < ActionDispatch::IntegrationTest
  test "show: renders successfully when given a visible, unused membership_invitation token" do
    membership_invitation = MembershipInvitation.find_by!(email: users.invited_user_1.email)
    token = membership_invitation.generate_token_for(:invitation)
    get membership_invitation_url(token)
    assert_response :ok
  end

  test "show: returns 404 if a used membership_invitation token is given" do
    membership_invitation = users.invited_user_2.membership_invitations.first
    token = membership_invitation.generate_token_for(:invitation)

    get membership_invitation_url(token)
    assert_response :not_found
  end

  test "show: returns 404 if a hidden membership_invitation token is given" do
    membership_invitation = MembershipInvitation.find_by!(email: users.invited_user_1.email)
    membership_invitation.update!(visible: false)
    token = membership_invitation.generate_token_for(:invitation)

    get membership_invitation_url(token)
    assert_response :not_found
  end

  test "show: raises ActiveSupport::MessageVerifier::InvalidSignature if a bad token is given" do
    token = "bad"

    assert_raises ActiveSupport::MessageVerifier::InvalidSignature do
      get membership_invitation_url(token)
    end
  end

  test "show: raises ActiveSupport::MessageVerifier::InvalidSignature if a raw token is given" do
    membership_invitation = MembershipInvitation.find_by!(email: users.invited_user_1.email)

    assert_raises ActiveSupport::MessageVerifier::InvalidSignature do
      get membership_invitation_url(membership_invitation.id)
    end
  end

  test "sign_out_then_show: signs out the user, but stores the path" do
    user = users.apprentice
    sign_in(user)

    membership_invitation = MembershipInvitation.find_by!(email: users.invited_user_1.email)
    token = membership_invitation.generate_token_for(:invitation)
    delete sign_out_then_show_membership_invitation_url(token)
    assert_redirected_to membership_invitation_url(token)
  end

  test "sign_out_then_show: returns 404 if a used membership_invitation token is given" do
    user = users.invited_user_1
    sign_in(user)

    membership_invitation = users.invited_user_2.membership_invitations.first
    token = membership_invitation.generate_token_for(:invitation)

    delete sign_out_then_show_membership_invitation_url(token)
    assert_response :not_found
  end

  test "sign_out_then_show: returns 404 if a hidden membership_invitation token is given" do
    user = users.invited_user_1
    sign_in(user)

    membership_invitation = MembershipInvitation.find_by!(email: users.invited_user_1.email)
    membership_invitation.update!(visible: false)
    token = membership_invitation.generate_token_for(:invitation)

    delete sign_out_then_show_membership_invitation_url(token)
    assert_response :not_found
  end

  test "sign_out_then_show: raises ActiveSupport::MessageVerifier::InvalidSignature if a bad token is given" do
    user = users.invited_user_1
    sign_in(user)

    token = "bad"

    assert_raises ActiveSupport::MessageVerifier::InvalidSignature do
      delete sign_out_then_show_membership_invitation_url(token)
    end
  end

  test "sign_out_then_show: raises ActiveSupport::MessageVerifier::InvalidSignature if a raw token is given" do
    user = users.invited_user_1
    sign_in(user)

    membership_invitation = MembershipInvitation.find_by!(email: users.invited_user_1.email)

    assert_raises ActiveSupport::MessageVerifier::InvalidSignature do
      delete sign_out_then_show_membership_invitation_url(membership_invitation.id)
    end
  end

  test "accept_as_current_user: links the invitation to a given user, creating the final membership" do
    user = users.invited_user_1
    sign_in(user)

    membership_invitation = MembershipInvitation.find_by!(email: users.invited_user_1.email)
    token = membership_invitation.generate_token_for(:invitation)
    assert_difference "Membership.count", +1 do
      patch accept_as_current_user_membership_invitation_url(token)
    end

    assert_redirected_to organization_url(membership_invitation.organization)
    message = I18n.t('membership_invitations.accepted_message', organization_name: membership_invitation.organization.name)
    assert_flash_message(type: :success, message: message, icon_name: 'solid-warehouse-circle-check')

    membership = membership_invitation.reload.membership

    assert_equal true, membership.active?
    assert_equal user, membership.user
    assert_equal user, membership_invitation.user

    assert_equal membership_invitation.organization, membership.organization
    assert_equal membership_invitation.membership_type, membership.membership_type
  end

  test "accept_as_current_user: links the invitation to a given user, even if the email does not match" do
    user = users.apprentice
    sign_in(user)

    membership_invitation = MembershipInvitation.find_by!(email: users.invited_user_1.email)
    token = membership_invitation.generate_token_for(:invitation)

    assert_difference "Membership.count", +1 do
      patch accept_as_current_user_membership_invitation_url(token)
    end

    assert_redirected_to organization_url(membership_invitation.organization)
    message = I18n.t('membership_invitations.accepted_message', organization_name: membership_invitation.organization.name)
    assert_flash_message(type: :success, message: message, icon_name: 'solid-warehouse-circle-check')

    membership = membership_invitation.reload.membership

    assert_equal true, membership.active?
    assert_equal user, membership.user
    assert_equal user, membership_invitation.user

    assert_equal membership_invitation.organization, membership.organization
    assert_equal membership_invitation.membership_type, membership.membership_type
  end

  test "accept_as_current_user: raises an error and does not change the invitation if the user is already a member of this organization" do
    user = users.organization_3_owner
    sign_in(user)

    membership_invitation = MembershipInvitation.find_by!(email: users.invited_user_1.email)
    token = membership_invitation.generate_token_for(:invitation)

    assert_no_difference "Membership.count" do
      patch accept_as_current_user_membership_invitation_url(token)
    end

    assert_response :unprocessable_entity
    message = I18n.t('activerecord.errors.models.membership.attributes.user.taken')
    assert_flash_message(type: :alert, message: message, icon_name: 'triangle-exclamation')

    assert_nil membership_invitation.reload.membership
  end

  test "accept_as_current_user: returns 404 if a used membership_invitation token is given" do
    user = users.invited_user_1
    sign_in(user)

    membership_invitation = users.invited_user_2.membership_invitations.first
    token = membership_invitation.generate_token_for(:invitation)

    patch accept_as_current_user_membership_invitation_url(token)
    assert_response :not_found
  end

  test "accept_as_current_user: returns 404 if a hidden membership_invitation token is given" do
    user = users.invited_user_1
    sign_in(user)

    membership_invitation = MembershipInvitation.find_by!(email: users.invited_user_1.email)
    membership_invitation.update!(visible: false)
    token = membership_invitation.generate_token_for(:invitation)

    patch accept_as_current_user_membership_invitation_url(token)
    assert_response :not_found
  end

  test "accept_as_current_user: raises ActiveSupport::MessageVerifier::InvalidSignature if a bad token is given" do
    user = users.invited_user_1
    sign_in(user)

    token = "bad"

    assert_raises ActiveSupport::MessageVerifier::InvalidSignature do
      patch accept_as_current_user_membership_invitation_url(token)
    end
  end

  test "accept_as_current_user: raises ActiveSupport::MessageVerifier::InvalidSignature if a raw token is given" do
    user = users.invited_user_1
    sign_in(user)

    membership_invitation = MembershipInvitation.find_by!(email: users.invited_user_1.email)

    assert_raises ActiveSupport::MessageVerifier::InvalidSignature do
      patch accept_as_current_user_membership_invitation_url(membership_invitation.id)
    end
  end
end
