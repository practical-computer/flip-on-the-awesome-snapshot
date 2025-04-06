# frozen_string_literal: true

class OrganizationNameComponentPreview < ViewComponent::Preview
  def default
    render(OrganizationNameComponent.new(organization: Organization.first))
  end
end
