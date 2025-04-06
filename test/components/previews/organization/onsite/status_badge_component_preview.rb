# frozen_string_literal: true

class Organization::Onsite::StatusBadgeComponentPreview < ViewComponent::Preview
  def default
    render(Organization::Onsite::StatusBadgeComponent.new(onsite: Organization::Onsite.first))
  end
end
