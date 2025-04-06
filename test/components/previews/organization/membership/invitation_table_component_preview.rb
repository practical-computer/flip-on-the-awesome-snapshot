# frozen_string_literal: true

class Organization::Membership::InvitationTableComponentPreview < ViewComponent::Preview
  def default
    render(Organization::Membership::InvitationTableComponent.new(membership_invitations: "membership_invitations"))
  end
end
