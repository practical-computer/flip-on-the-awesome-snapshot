# frozen_string_literal: true

class Organization::Membership::TableComponentPreview < ViewComponent::Preview
  def default
    render(Organization::Membership::TableComponent.new(memberships: "memberships"))
  end
end
