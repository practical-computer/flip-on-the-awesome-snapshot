# frozen_string_literal: true

class Forms::Organization::MembershipInvitationFormComponentPreview < ViewComponent::Preview
  def default
    render(Forms::Organization::MembershipInvitationFormComponent.new(form: "form"))
  end
end
