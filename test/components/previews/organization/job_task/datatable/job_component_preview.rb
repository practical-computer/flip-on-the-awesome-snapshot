# frozen_string_literal: true

class Organization::JobTask::Datatable::JobComponentPreview < ViewComponent::Preview
  def default
    render(Organization::JobTask::Datatable::JobComponent.new(datatable_form: "datatable_form", job_tasks: "job_tasks", pagy: "pagy", request: "request"))
  end
end
