# frozen_string_literal: true

class User::Membership::TableComponentPreview < ViewComponent::Preview
  def default
    render(User::Membership::TableComponent.new(memberships: "memberships"))
  end
end
