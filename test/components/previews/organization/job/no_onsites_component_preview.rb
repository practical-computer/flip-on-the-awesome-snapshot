# frozen_string_literal: true

class Organization::Job::NoOnsitesComponentPreview < ViewComponent::Preview
  def default
    render(Organization::Job::NoOnsitesComponent.new)
  end
end
