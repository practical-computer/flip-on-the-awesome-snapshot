# frozen_string_literal: true

class Organization::Job::NoTasksComponentPreview < ViewComponent::Preview
  def default
    render(Organization::Job::NoTasksComponent.new(job: "job"))
  end
end
