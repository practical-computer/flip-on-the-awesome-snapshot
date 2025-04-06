# frozen_string_literal: true

class CustomViewComponentsController < ViewComponentsController
  helper_method :main_application_navigation_link_key

  def main_application_navigation_link_key
    :test_selected
  end
end