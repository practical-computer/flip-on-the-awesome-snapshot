# frozen_string_literal: true

class Administrator::SessionsController < Devise::SessionsController
  include Devise::Controllers::Rememberable
  include Devise::Passkeys::Controllers::SessionsControllerConcern
  include AdministratorRelyingParty

  skip_verify_authorized

  layout "administrator"

  def set_relying_party_in_request_env
    request.env[relying_party_key] = relying_party
  end

  def create
    super do |user|
      remember_me(user)
    end
  end
end
