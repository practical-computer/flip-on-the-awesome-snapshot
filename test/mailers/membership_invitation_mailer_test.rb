# frozen_string_literal: true

require "test_helper"
require "practical_framework/test_helpers/postmark_template_helpers"

class MembershipInvitationMailerTest < ActionMailer::TestCase
  include PracticalFramework::TestHelpers::PostmarkTemplateHelpers
  include Rails.application.routes.url_helpers

  test "invitation" do
    membership_invitation = MembershipInvitation.unused.first

    Timecop.freeze(Time.now.utc) do
      mail = MembershipInvitationMailer.invitation(membership_invitation: membership_invitation)

      assert_equal "Postmark Template: \"membership-invitation\"", mail.subject
      assert_equal [membership_invitation.email], mail.to
      assert_equal [membership_invitation.sender.email], mail.reply_to
      assert_equal [AppSettings.support_email], mail.from

      template_model = extract_template_model(mail: mail)

      token = membership_invitation.generate_token_for(:invitation)

      assert_equal "there", template_model["name"]
      assert_equal membership_invitation.sender.name, template_model["invite_sender_name"]
      assert_equal membership_invitation.organization.name, template_model["organization_name"]
      assert_equal membership_invitation_url(token), template_model["action_url"]

      assert_equal root_url, template_model["product_url"]
      assert_equal AppSettings.app_name, template_model["product_name"]
      assert_equal AppSettings.support_url, template_model["support_url"]
      assert_equal AppSettings.company_name, template_model["company_name"]
      assert_equal AppSettings.company_address, template_model["company_address"]
    end
  end

  test "invitation_accepted" do
    membership_invitation = users.invited_user_2.membership_invitations.first

    mail = MembershipInvitationMailer.invitation_accepted(membership_invitation: membership_invitation)

    assert_equal "Postmark Template: \"membership-invitation-accepted\"", mail.subject
    assert_equal [membership_invitation.email], mail.to
    assert_nil mail.reply_to
    assert_equal [AppSettings.support_email], mail.from

    template_model = extract_template_model(mail: mail)

    token = membership_invitation.generate_token_for(:invitation)

    assert_equal membership_invitation.user.name, template_model["name"]
    assert_equal membership_invitation.organization.name, template_model["organization_name"]

    assert_equal root_url, template_model["product_url"]
    assert_equal AppSettings.app_name, template_model["product_name"]
    assert_equal AppSettings.support_url, template_model["support_url"]
    assert_equal AppSettings.company_name, template_model["company_name"]
    assert_equal AppSettings.company_address, template_model["company_address"]
  end
end
