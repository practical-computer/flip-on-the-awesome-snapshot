# frozen_string_literal: true

class Forms::JobFormComponentPreview < ViewComponent::Preview
  def default
    organization = Organization.first
    user = organization.memberships.first.user
    form = Organization::JobForm.new(
      current_organization: organization,
      current_user: user
    )
    render(Forms::JobFormComponent.new(form: form))
  end
end
