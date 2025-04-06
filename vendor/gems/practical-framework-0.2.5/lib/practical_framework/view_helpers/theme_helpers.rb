# frozen_string_literal: true

module PracticalFramework::ViewHelpers::ThemeHelpers
  def theme_attribute
    if user_signed_in?
      return current_user.theme
    else
      return "match-system"
    end
  end

  def user_theme_options
    PracticalFramework::ThemeOptions.options(helpers: self)
  end
end