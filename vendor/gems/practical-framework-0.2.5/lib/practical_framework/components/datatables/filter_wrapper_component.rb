# frozen_string_literal: true

class PracticalFramework::Components::Datatables::FilterWrapperComponent < Phlex::HTML
  attr_accessor :datatable_params, :title, :icon

  def initialize(datatable_params:, title:)
    self.datatable_params = datatable_params
    self.title = title
  end

  def view_template
    details(class: "box-compact stack-compact rounded compact-size") {
      summary_section
      div(class: "details-contents") {
        yield
      }
    }
  end

  def summary_section
    summary {
      div(classes: "cluster-default") {
        unsafe_raw(helpers.details_icon)
        span {
          unsafe_raw(filter_icon)
          whitespace
          plain(title)
        }
      }
    }
  end

  def filter_icon
    if datatable_params&.present?
      helpers.filters_icon
    else
      helpers.apply_filters_icon
    end
  end
end