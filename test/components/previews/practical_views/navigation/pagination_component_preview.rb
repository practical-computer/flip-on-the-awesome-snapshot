# frozen_string_literal: true

class PracticalViews::Navigation::PaginationComponentPreview < ViewComponent::Preview
  def default
    render(PracticalViews::Navigation::PaginationComponent.new(pagy_instance: "pagy_instance", request: "request", item_name: "item_name", i18n_key: "i18n_key"))
  end
end
