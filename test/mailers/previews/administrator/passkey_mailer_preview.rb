# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/passkey_mailer
class Administrator::PasskeyMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/passkey_mailer/passkey_added
  def passkey_added
    administrator = Administrator.new(email: Faker::Internet.email)
    passkey = Administrator::Passkey.new(administrator: administrator, label: Faker::Computer.stack, created_at: Time.now.utc)
    Administrator::PasskeyMailer.passkey_added(passkey: passkey).prerender
  end

  # Preview this email at http://localhost:3000/rails/mailers/passkey_mailer/passkey_deleted
  def passkey_removed
    administrator = Administrator.new(email: Faker::Internet.email)
    Administrator::PasskeyMailer.passkey_removed(
      administrator: administrator,
      passkey_label: Faker::Computer.stack,
      deleted_at: Time.now.utc
    ).prerender
  end
end
