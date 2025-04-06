# frozen_string_literal: true

module PracticalViews::Datatable
  extend ActiveSupport::Concern

  def sort_link_for(key:, &block)
    component = PracticalViews::Datatable::SortLinkComponent.new(
      url: sort_url_for(key: key),
      datatable_form: datatable_form,
      sort_key: key,
      options: {class: "wa-flank wa-gap-2xs"}
    )

    render(component, &block)
  end

  def pagination_component
    return PracticalViews::Navigation::PaginationComponent.new(
      pagy: pagy,
      request: request,
      i18n_key: "pagy.item_name"
    )
  end
end