# frozen_string_literal: true

class PracticalFramework::Components::Breadcrumbs < Phlex::HTML
  include Loaf::ViewExtensions
  include FontAwesomeHelpers::ViewHelpers
  include Phlex::Rails::Helpers::ContentTag

  attr_accessor :breadcrumb_trail, :collapse_after

  def initialize(breadcrumb_trail:, collapse_after: 5)
    self.breadcrumb_trail = breadcrumb_trail
    self.collapse_after = collapse_after
  end

  def view_template
    if collapse?
      collapsed_breadcrumbs
    else
      breadcrumbs(inside_details: false)
    end
  end

  def collapse?
    breadcrumb_trail.count > collapse_after
  end

  def collapsed_breadcrumbs
    nav("class": 'cluster-compact', "aria-label": "Breadcrumbs") {
      details(class: tokens(:"box-extra-compact", :rounded)) {
        summary {
          icon(style: "fa-solid", name: "chevron-down", html_options: {class: "details-marker"})
          whitespace
          span { "Breadcrumbs" }
        }

        breadcrumbs(inside_details: true)
      }
    }
  end

  def breadcrumbs(inside_details:)
    ol(class: tokens(:"cluster-compact", -> { inside_details} => :"details-contents")) {
      last_index = breadcrumb_trail.count - 1
      breadcrumb_trail.each_with_index do |crumb, i|
        li {
          content = capture {
            unsafe_raw(crumb.name)

            if i < last_index
              icon(style: "fa-solid", name: "chevron-right", html_options: {class: 'disabled-link'})
            end
          }

          if crumb.current?
            span("class": 'cluster-compact disabled-link', "aria-current": :page){ content }
          else
            a(href: crumb.url, class: 'cluster-compact'){ content }
          end
        }
      end
    }
  end
end
