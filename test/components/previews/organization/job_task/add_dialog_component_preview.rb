# frozen_string_literal: true

class Organization::JobTask::AddDialogComponentPreview < ViewComponent::Preview
  def default
    render(Organization::JobTask::AddDialogComponent.new(form: "form"))
  end
end
