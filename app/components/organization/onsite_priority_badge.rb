# frozen_string_literal: true

class Organization::OnsitePriorityBadge < Phlex::HTML
  attr_accessor :onsite

  def initialize(onsite:)
    self.onsite = onsite
  end

  def view_template
    class_tokens = tokens("badge labeled-badge compact-size rounded onsite-priority-badge",
                          onsite.priority
                        )
    span(class: class_tokens, title: title) {
      unsafe_raw helpers.onsite_priority_icon(priority: onsite.priority)
      whitespace
      plain title
    }
  end

  def title
    helpers.human_onsite_priority(priority: onsite.priority)
  end
end