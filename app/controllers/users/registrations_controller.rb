# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  include Devise::Passkeys::Controllers::RegistrationsControllerConcern
  include RelyingParty

  prepend_before_action :check_if_self_service_registration_allowed, only: [:new_challenge, :new, :create]
  prepend_before_action :check_if_self_service_destruction_allowed, only: [:destroy]

  breadcrumb "user_settings", :edit_user_registration_url, except: [:new, :create]
  breadcrumb "user_signup", :new_user_registration_url, only: [:new, :create]
  before_action :configure_permitted_parameters

  layout :resolve_layout

  helper_method :main_application_navigation_link_key

  skip_verify_authorized only: [:new, :new_challenge, :create]
  before_action :authorize_management, except: [:new, :new_challenge, :create]

  def main_application_navigation_link_key
    :user_profile
  end

  def update
    super do |resource|
      if resource.persisted? && resource.valid?
        json_redirect(location: edit_user_registration_url)
        return
      else
        errors = PracticalFramework::FormBuilders::Base.build_error_json(model: resource, helpers: helpers)
        render json: errors, status: :bad_request
        return
      end
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email])
  end

  def check_if_self_service_registration_allowed
    return if Flipper.enabled?(:self_service_user_registration)
    head :not_implemented
    return
  end

  def check_if_self_service_destruction_allowed
    return if Flipper.enabled?(:self_service_user_destruction)
    head :not_implemented
    return
  end

  def resolve_layout
    case params[:action]
    when "new", "create"
      "app_chrome"
    else
      if using_web_awesome?
        "user_settings"
      else
        "main_application"
      end
    end
  end

  def authorize_management
    authorize!(current_user, to: :manage?, with: UserPolicy)
  end
end
