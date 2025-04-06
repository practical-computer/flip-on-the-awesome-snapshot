# frozen_string_literal: true

class Organization::Job::Datatable::FilterComponentPreview < ViewComponent::Preview
  def default
    render(Organization::Job::Datatable::FilterComponent.new(datatable_form: "datatable_form", url: "url"))
  end
end
