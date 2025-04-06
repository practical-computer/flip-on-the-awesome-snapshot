# frozen_string_literal: true

class Organization::Onsite::StatusTagComponentPreview < ViewComponent::Preview
  def default
    render(Organization::Onsite::StatusTagComponent.new(onsite: Organization::Onsite.first))
  end
end
