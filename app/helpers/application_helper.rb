# frozen_string_literal: true

module ApplicationHelper
  include PracticalViews::ElementHelper

  def icon_set
    ApplicationIconSet
  end

  def initials(name:)
    space_split = name.split(" ")
    if space_split.size >= 2
      return space_split.first(2).map{|x| x[0]&.upcase }.join("")
    end

    return name.first(2).upcase
  end

  def icon_text(icon:, text:, options: {})
    tag.span(**mix({class: "wa-flank wa-gap-3xs icon-text"}, options)) {
      safe_join([
        (render icon),
        tag.span(text)
      ])
    }
  end

  def v2_user_theme_options
    [
      PracticalFramework::Forms::CollectionOption.new(
        value: "match-system",
        title: "Automatically Switch",
        description: "We'll change between Peach & Apple based on your device's dark/light mode settings",
        icon: icon_set.match_system_theme_icon
      ),
      PracticalFramework::Forms::CollectionOption.new(
        value: "light",
        title: "Peach",
        description: "A playful, but functional, light mode",
        icon: icon_set.light_theme_icon
      ),
      PracticalFramework::Forms::CollectionOption.new(
        value: "dark",
        title: "Apple",
        description: "A colorful dark mode",
        icon: icon_set.dark_theme_icon
      ),
    ]
  end
end
