# frozen_string_literal: true

class PracticalFramework::Components::Datatables::SortLink < Phlex::HTML
  attr_accessor :url, :datatable_form, :sort_key

  def initialize(url:, datatable_form:, sort_key:)
    self.url = url
    self.datatable_form = datatable_form
    self.sort_key = sort_key
  end

  def view_template(&block)
    a(href: url) {
      unsafe_raw(icon)
      yield
    }
  end

  def icon
    case sort_direction
    when "desc"
      return helpers.descending_icon
    when "asc"
      return helpers.ascending_icon
    else
      return helpers.sort_icon
    end
  end

  def sort_direction
    datatable_form.sort_direction_for(key: sort_key)
  end

  def self.inverted_sort_direction(datatable_form:, sort_key:)
    datatable_form.inverted_sort_direction_for(key: sort_key)
  end

  def self.merged_payload(datatable_form:, sort_key:)
    datatable_form.merged_payload(sort_key: sort_key,
                                  sort_direction: inverted_sort_direction(datatable_form: datatable_form,
                                                                          sort_key: sort_key
                                                                        )
                                 )
  end
end