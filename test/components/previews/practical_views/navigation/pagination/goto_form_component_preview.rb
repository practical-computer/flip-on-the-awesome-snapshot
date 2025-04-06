# frozen_string_literal: true

class PracticalViews::Navigation::Pagination::GotoFormComponentPreview < ViewComponent::Preview
  def default
    render(PracticalViews::Navigation::Pagination::GotoFormComponent.new(pagy: "pagy"))
  end
end
