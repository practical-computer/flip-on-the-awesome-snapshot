# frozen_string_literal: true

class Organization::Onsite::PriorityBadgeComponentPreview < ViewComponent::Preview
  def regular_priority
    render(Organization::Onsite::PriorityBadgeComponent.new(priority: :regular_priority))
  end

  def high_priority
    render(Organization::Onsite::PriorityBadgeComponent.new(priority: :high_priority))
  end
end
