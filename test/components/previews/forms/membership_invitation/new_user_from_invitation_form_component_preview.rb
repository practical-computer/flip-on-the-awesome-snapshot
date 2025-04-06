# frozen_string_literal: true

class Forms::MembershipInvitation::NewUserFromInvitationFormComponentPreview < ViewComponent::Preview
  def default
    render(Forms::MembershipInvitation::NewUserFromInvitationFormComponent.new(form: "form"))
  end
end
