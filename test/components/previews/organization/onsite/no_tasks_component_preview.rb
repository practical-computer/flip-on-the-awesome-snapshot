# frozen_string_literal: true

class Organization::Onsite::NoTasksComponentPreview < ViewComponent::Preview
  def default
    render(Organization::Onsite::NoTasksComponent.new(job_task_form: "job_task_form"))
  end
end
