# frozen_string_literal: true

module PracticalFramework::SharedTestModules::Controllers::Users::MembershipInvitationsController::BaseTests
  extend ActiveSupport::Concern
  included do
    test "destroy: destroys a pending invitation and returns a flash message" do
      user = users.invited_user_1
      sign_in(user)

      membership_invitation = MembershipInvitation.find_by!(email: user.email)

      assert_policies_applied(user: user, membership_invitation: membership_invitation) do
      assert_difference "MembershipInvitation.count", -1 do
        delete user_hide_membership_invitation_url(membership_invitation)
      end
      end

      assert_redirected_to user_memberships_url
      message = I18n.t('user_memberships.invitation_hidden_message', organization_name: membership_invitation.organization.name)
      assert_flash_message(type: :alert, message: message, icon_name: 'solid-warehouse-slash')
    end

    test "destroy: returns 404 if the invitation is already tied to a user" do
      user = users.invited_user_2
      sign_in(user)

      membership_invitation = MembershipInvitation.find_by!(email: user.email)

      assert_policies_applied_on_404(user: user) do
      assert_no_difference "MembershipInvitation.count" do
        delete user_hide_membership_invitation_url(membership_invitation)
      end
      end

      assert_response :not_found
      assert_no_enqueued_emails
    end

    test "destroy: returns 404 if the invitation is not visible" do
      user = users.invited_user_1
      sign_in(user)

      membership_invitation = MembershipInvitation.find_by!(email: user.email)
      membership_invitation.update!(visible: false)

      assert_policies_applied_on_404(user: user) do
      assert_no_difference "MembershipInvitation.count" do
        delete user_hide_membership_invitation_url(membership_invitation)
      end
      end

      assert_response :not_found
      assert_no_enqueued_emails
    end
  end
end