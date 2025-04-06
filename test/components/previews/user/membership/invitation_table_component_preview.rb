# frozen_string_literal: true

class User::Membership::InvitationTableComponentPreview < ViewComponent::Preview
  def default
    render(User::Membership::InvitationTableComponent.new(membership_invitations: "membership_invitations"))
  end
end
