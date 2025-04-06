# frozen_string_literal: true

class Organization::JobTask::StatusTagComponentPreview < ViewComponent::Preview
  def default
    render(Organization::JobTask::StatusTagComponent.new(status: "todo"))
  end
end
