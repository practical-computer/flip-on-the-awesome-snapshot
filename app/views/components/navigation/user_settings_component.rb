# frozen_string_literal: true

class Navigation::UserSettingsComponent < ApplicationComponent
  attr_accessor :current_user
  def initialize(current_user:)
    @current_user = current_user
  end
end
