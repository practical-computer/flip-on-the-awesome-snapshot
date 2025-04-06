# frozen_string_literal: true

module PracticalViews::Datatable::FilterApplied
  extend ActiveSupport::Concern

  def dialog_button_appearance
    if custom_filters_applied?
      return "filled outlined"
    else
      return "outlined"
    end
  end

  def custom_filters_applied?
    datatable_form.filters.to_h.compact != datatable_form.class.default_payload[:filters]
  end

  def filter_icon
    if custom_filters_applied?
      helpers.icon_set.filters_icon
    else
      helpers.icon_set.apply_filters_icon
    end
  end
end