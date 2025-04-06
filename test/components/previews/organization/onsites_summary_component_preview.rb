# frozen_string_literal: true

class Organization::OnsitesSummaryComponentPreview < ViewComponent::Preview
  def default
    render(Organization::OnsitesSummaryComponent.new(onsites: Organization::Onsite.all))
  end
end
