# frozen_string_literal: true

class MembershipInvitationMailer < ApplicationMailer
  include PostmarkRails::TemplatedMailerMixin
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.membership_invitation_mailer.invitation.subject
  #
  def invitation(membership_invitation:)
    self.template_model = {
      name: "there",
      invite_sender_name: membership_invitation.sender.name,
      product_url: root_url,
      product_name: AppSettings.app_name,
      organization_name: membership_invitation.organization.name,
      action_url: membership_invitation_url(membership_invitation.generate_token_for(:invitation)),
      support_url: AppSettings.support_url,
      company_name: AppSettings.company_name,
      company_address: AppSettings.company_address
    }

    mail(to: membership_invitation.email,
         reply_to: membership_invitation.sender.email,
         postmark_template_alias: 'membership-invitation'
        )
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.membership_invitation_mailer.invitation_accepted.subject
  #
  def invitation_accepted(membership_invitation:)
    self.template_model = {
      name: membership_invitation.user.name,
      product_url: root_url,
      product_name: AppSettings.app_name,
      organization_name: membership_invitation.organization.name,
      support_url: AppSettings.support_url,
      company_name: AppSettings.company_name,
      company_address: AppSettings.company_address
    }

    mail to: membership_invitation.email, postmark_template_alias: 'membership-invitation-accepted'
  end
end
