# frozen_string_literal: true

class Navigation::OrganizationSwitcherComponentPreview < ViewComponent::Preview
  def default
    organization = Organization.first
    user = organization.memberships.first.user
    render(Navigation::OrganizationSwitcherComponent.new(
      current_user: user,
      current_organization: organization
    ))
  end
end
