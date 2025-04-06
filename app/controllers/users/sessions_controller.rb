# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include Devise::Controllers::Rememberable
  include Devise::Passkeys::Controllers::SessionsControllerConcern
  include RelyingParty

  skip_verify_authorized

  layout "app_chrome"

  def set_relying_party_in_request_env
    request.env[relying_party_key] = relying_party
  end

  def create
    super do |user|
      remember_me(user)
    end
  end

  def emergency_login
    resource = User.find_by_token_for!(:emergency_login, params[:id])
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    redirect_to after_sign_in_path_for(resource)
  end
end
