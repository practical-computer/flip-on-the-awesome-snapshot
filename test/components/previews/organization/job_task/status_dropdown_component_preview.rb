# frozen_string_literal: true

class Organization::JobTask::StatusDropdownComponentPreview < ViewComponent::Preview
  def default
    render(Organization::JobTask::StatusDropdownComponent.new(job_task: Organization::JobTask.first))
  end
end
