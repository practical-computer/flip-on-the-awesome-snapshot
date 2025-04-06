# frozen_string_literal: true

class Forms::Organization::MembershipFormComponentPreview < ViewComponent::Preview
  def default
    render(Forms::Organization::MembershipFormComponent.new(form: "form"))
  end
end
