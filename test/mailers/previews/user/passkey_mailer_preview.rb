# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/passkey_mailer
class User::PasskeyMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/passkey_mailer/passkey_added
  def passkey_added
    user = User.new(name: Faker::Name.name, email: Faker::Internet.email)
    passkey = User::Passkey.new(user: user, label: Faker::Computer.stack, created_at: Time.now.utc)
    User::PasskeyMailer.passkey_added(passkey: passkey).prerender
  end

  # Preview this email at http://localhost:3000/rails/mailers/passkey_mailer/passkey_deleted
  def passkey_removed
    user = User.new(name: Faker::Name.name, email: Faker::Internet.email)
    User::PasskeyMailer.passkey_removed(
      user: user,
      passkey_label: Faker::Computer.stack,
      deleted_at: Time.now.utc
    ).prerender
  end
end
