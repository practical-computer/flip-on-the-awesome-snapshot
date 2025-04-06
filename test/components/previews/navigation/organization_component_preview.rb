# frozen_string_literal: true

class Navigation::OrganizationComponentPreview < ViewComponent::Preview
  def default
    render(Navigation::OrganizationComponent.new(organization: Organization.first))
  end
end
