# frozen_string_literal: true

class MembershipInvitation::DetailsComponentPreview < ViewComponent::Preview
  def default
    render(MembershipInvitation::DetailsComponent.new(membership_invitation: "membership_invitation"))
  end
end
