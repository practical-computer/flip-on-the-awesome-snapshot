# frozen_string_literal: true

require "test_helper"
require "practical_framework/test_helpers/postmark_template_helpers"

class Administrator::PasskeyMailerTest < ActionMailer::TestCase
  include PracticalFramework::TestHelpers::PostmarkTemplateHelpers
  include Rails.application.routes.url_helpers

  test "passkey_added" do
    passkey = administrators.kira.passkeys.first

    mail = Administrator::PasskeyMailer.passkey_added(passkey: passkey)

    assert_equal "Postmark Template: \"passkey-added\"", mail.subject
    assert_equal [passkey.administrator.email], mail.to
    assert_equal [AppSettings.support_email], mail.from


    template_model = extract_template_model(mail: mail)

    assert_equal root_url, template_model["product_url"]
    assert_equal AppSettings.app_name, template_model["product_name"]
    assert_equal "Administrator", template_model["name"]
    assert_equal passkey.label, template_model["passkey_label"]
    assert_equal passkey.created_at.to_formatted_s(:rfc822), template_model["passkey_added_at"]
    assert_equal AppSettings.support_url, template_model["support_url"]
    assert_equal AppSettings.company_name, template_model["company_name"]
    assert_equal AppSettings.company_address, template_model["company_address"]
  end

  test "passkey_removed" do
    administrator = administrators.kira
    label = Faker::Computer.stack
    deleted_at = Time.now.utc

    mail = Administrator::PasskeyMailer.passkey_removed(
      administrator: administrator,
      passkey_label: label,
      deleted_at: deleted_at
    )

    assert_equal "Postmark Template: \"passkey-removed\"", mail.subject
    assert_equal [administrator.email], mail.to
    assert_equal [AppSettings.support_email], mail.from


    template_model = extract_template_model(mail: mail)

    assert_equal root_url, template_model["product_url"]
    assert_equal AppSettings.app_name, template_model["product_name"]
    assert_equal "Administrator", template_model["name"]
    assert_equal label, template_model["passkey_label"]
    assert_equal deleted_at.to_formatted_s(:rfc822), template_model["passkey_removed_at"]
    assert_equal AppSettings.support_url, template_model["support_url"]
    assert_equal AppSettings.company_name, template_model["company_name"]
    assert_equal AppSettings.company_address, template_model["company_address"]
  end
end
