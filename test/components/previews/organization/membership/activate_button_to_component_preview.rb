# frozen_string_literal: true

class Organization::Membership::ActivateButtonToComponentPreview < ViewComponent::Preview
  def default
    render(Organization::Membership::ActivateButtonToComponent.new(membership: "membership"))
  end
end
