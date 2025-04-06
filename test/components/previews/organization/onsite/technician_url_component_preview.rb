# frozen_string_literal: true

class Organization::Onsite::TechnicianUrlComponentPreview < ViewComponent::Preview
  def default
    render(Organization::Onsite::TechnicianUrlComponent.new(onsite: "onsite"))
  end
end
