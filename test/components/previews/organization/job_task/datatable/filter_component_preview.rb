# frozen_string_literal: true

class Organization::JobTask::Datatable::FilterComponentPreview < ViewComponent::Preview
  def default
    render(Organization::JobTask::Datatable::FilterComponent.new(datatable_form: "datatable_form", url: "url"))
  end
end
