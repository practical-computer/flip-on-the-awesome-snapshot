# frozen_string_literal: true

class Organization::Onsite::DetailsComponentPreview < ViewComponent::Preview
  def default
    render(Organization::Onsite::DetailsComponent.new(onsite: "onsite"))
  end
end
