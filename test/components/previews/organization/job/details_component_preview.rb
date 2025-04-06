# frozen_string_literal: true

class Organization::Job::DetailsComponentPreview < ViewComponent::Preview
  def default
    render(Organization::Job::DetailsComponent.new(job: Organization::Job.first))
  end
end
