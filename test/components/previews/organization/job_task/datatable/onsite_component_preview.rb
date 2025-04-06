# frozen_string_literal: true

class Organization::JobTask::Datatable::OnsiteComponentPreview < ViewComponent::Preview
  def default
    render(Organization::JobTask::Datatable::OnsiteComponent.new)
  end
end
