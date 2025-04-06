# frozen_string_literal: true

class Users::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_current_user
  authorize :user, through: :current_user

  layout :resolve_layout

  protected

  def resolve_layout
    return "user_settings" if using_web_awesome?
    return "main_application"
  end

  def authorize_current_user
    authorize!(current_user, to: :show?, with: UserPolicy)
  end
end