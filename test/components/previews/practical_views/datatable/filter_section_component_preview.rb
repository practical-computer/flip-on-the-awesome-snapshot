# frozen_string_literal: true

class PracticalViews::Datatable::FilterSectionComponentPreview < ViewComponent::Preview
  def default
    render(PracticalViews::Datatable::FilterSectionComponent.new)
  end
end
