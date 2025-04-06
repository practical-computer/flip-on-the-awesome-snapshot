# frozen_string_literal: true

class MembershipInvitation::AcceptAsCurrentUserComponentPreview < ViewComponent::Preview
  def default
    render(MembershipInvitation::AcceptAsCurrentUserComponent.new(membership_invitation: "membership_invitation"))
  end
end
