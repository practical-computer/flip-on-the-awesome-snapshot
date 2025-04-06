# frozen_string_literal: true

class Organization::JobTask::Datatable::BaseComponentPreview < ViewComponent::Preview
  def default
    render(Organization::JobTask::Datatable::BaseComponent.new(datatable_form: "datatable_form", job_tasks: "job_tasks", pagy: "pagy", request: "request"))
  end
end
