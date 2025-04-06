# frozen_string_literal: true

class Forms::User::ThemeFormComponent < ApplicationComponent
  attr_accessor :user
  def initialize(user:)
    @user = user
  end
end
