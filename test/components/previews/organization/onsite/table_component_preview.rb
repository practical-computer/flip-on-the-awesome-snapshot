# frozen_string_literal: true

class Organization::Onsite::TableComponentPreview < ViewComponent::Preview
  def default
    render(Organization::Onsite::TableComponent.new(onsites: "onsites"))
  end
end
