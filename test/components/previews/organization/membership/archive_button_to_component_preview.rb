# frozen_string_literal: true

class Organization::Membership::ArchiveButtonToComponentPreview < ViewComponent::Preview
  def default
    render(Organization::Membership::ArchiveButtonToComponent.new(membership: "membership"))
  end
end
