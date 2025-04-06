# frozen_string_literal: true

class Organization::JobTasksSummaryComponentPreview < ViewComponent::Preview
  def default
    render(Organization::JobTasksSummaryComponent.new(job_tasks: Organization::JobTask.all))
  end
end
