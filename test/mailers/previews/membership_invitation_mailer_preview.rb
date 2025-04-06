# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/membership_invitation_mailer
class MembershipInvitationMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/membership_invitation_mailer/invitation
  def invitation
    organization = Organization.new(name: Faker::Company.name)
    sender = User.new(name: Faker::Name.name, email: Faker::Internet.email)
    email = Faker::Internet.email

    membership_invitation = MembershipInvitation.new(id: 1234, organization: organization, sender: sender, email: email)
    MembershipInvitationMailer.invitation(membership_invitation: membership_invitation).prerender
  end

  # Preview this email at http://localhost:3000/rails/mailers/membership_invitation_mailer/invitation_accepted
  def invitation_accepted
    organization = Organization.new(name: Faker::Company.name)
    sender = User.new(name: Faker::Name.name, email: Faker::Internet.email)
    email = Faker::Internet.email
    user = User.new(name: Faker::Name.name, email: Faker::Internet.email)

    membership_invitation = MembershipInvitation.new(id: 1234, organization: organization, sender: sender, email: email, user: user)
    MembershipInvitationMailer.invitation_accepted(membership_invitation: membership_invitation).prerender
  end
end
