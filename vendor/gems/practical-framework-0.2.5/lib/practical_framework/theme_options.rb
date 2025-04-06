# frozen_string_literal: true

class PracticalFramework::ThemeOptions
  def self.options(helpers:)
    [
      match_system_theme_option(helpers: helpers),
      light_theme_option(helpers: helpers),
      dark_theme_option(helpers: helpers),
    ]
  end

  def self.light_theme_option(helpers:)
    OpenStruct.new(value: "light",
                   icon: light_theme_icon(helpers: helpers),
                   title: light_theme_title(helpers: helpers),
                   description: light_theme_description(helpers: helpers)
    )
  end

  def self.light_theme_icon(helpers:)
    helpers.icon(style: "fa-solid", name: "sun")
  end

  def self.light_theme_title(helpers:)
    "Peach"
  end

  def self.light_theme_description(helpers:)
    "A playful, but functional, light mode"
  end

  def self.dark_theme_option(helpers:)
    OpenStruct.new(value: "dark",
                   icon: dark_theme_icon(helpers: helpers),
                   title: dark_theme_title(helpers: helpers),
                   description: dark_theme_description(helpers: helpers)
    )
  end

  def self.dark_theme_icon(helpers:)
    helpers.icon(style: "fa-solid", name: "moon")
  end

  def self.dark_theme_title(helpers:)
    "Apple"
  end

  def self.dark_theme_description(helpers:)
    "A colorful dark mode"
  end

  def self.match_system_theme_option(helpers:)
    OpenStruct.new(value: "match-system",
                   icon: match_system_theme_icon(helpers: helpers),
                   title: match_system_theme_title(helpers: helpers),
                   description: match_system_theme_description(helpers: helpers)
    )
  end

  def self.match_system_theme_icon(helpers:)
    helpers.icon(style: "fa-solid", name: "circle-half-stroke")
  end

  def self.match_system_theme_title(helpers:)
    "Automatically Switch"
  end

  def self.match_system_theme_description(helpers:)
    "We'll change between Peach & Apple based on your device's dark/light mode settings"
  end
end
