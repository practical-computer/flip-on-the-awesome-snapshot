# frozen_string_literal: true

class PracticalViews::Datatable::FilterSectionComponent < PracticalViews::BaseComponent
  renders_one :open_filters_button
  renders_many :applied_filters,  "AppliedFilterComponent"

  class PracticalViews::Datatable::FilterSectionComponent::AppliedFilterComponent < PracticalViews::BaseComponent
    renders_one :title

    def call
      tag.section(class: "wa-stack wa-gap-0") do
        safe_join([
          tag.strong(title),
          content
        ])
      end
    end
  end
end
