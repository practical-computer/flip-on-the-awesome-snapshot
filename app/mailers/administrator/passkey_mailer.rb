# frozen_string_literal: true

class Administrator::PasskeyMailer < ApplicationMailer
  include PostmarkRails::TemplatedMailerMixin

  def passkey_added(passkey:)
    administrator = passkey.administrator
    passkey_label = passkey.label
    passkey_added_at = passkey.created_at.to_formatted_s(:rfc822)

    self.template_model = {
      product_url: root_url,
      product_name: AppSettings.app_name,
      name: "Administrator",
      passkey_label: passkey_label,
      passkey_added_at: passkey_added_at,
      support_url: AppSettings.support_url,
      company_name: AppSettings.company_name,
      company_address: AppSettings.company_address,
    }

    mail to: administrator.email, postmark_template_alias: 'passkey-added'
  end

  def passkey_removed(administrator:, passkey_label:, deleted_at:)
    self.template_model = {
      product_url: root_url,
      product_name: AppSettings.app_name,
      name: "Administrator",
      passkey_label: passkey_label,
      passkey_removed_at: deleted_at.to_formatted_s(:rfc822),
      support_url: AppSettings.support_url,
      company_name: AppSettings.company_name,
      company_address: AppSettings.company_address,
    }

    mail to: administrator.email, postmark_template_alias: 'passkey-removed'
  end
end
