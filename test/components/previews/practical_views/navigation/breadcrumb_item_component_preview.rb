# frozen_string_literal: true

class PracticalViews::Navigation::BreadcrumbItemComponentPreview < ViewComponent::Preview
  def no_icon
    render(PracticalViews::Navigation::BreadcrumbItemComponent.new.with_content("Home"))
  end

  def default
  end
end
