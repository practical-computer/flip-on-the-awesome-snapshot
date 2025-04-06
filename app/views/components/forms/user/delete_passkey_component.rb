# frozen_string_literal: true

class Forms::User::DeletePasskeyComponent < ApplicationComponent
  attr_accessor :passkey

  def initialize(passkey:)
    @passkey = passkey
  end

  def form_wrapper(&block)
    helpers.webawesome_form_with(
      model: passkey,
      scope: :passkey,
      url: user_passkey_url(passkey),
      method: :delete,
      data: {
        type: :json,
        reauthentication_challenge_url: new_destroy_challenge_user_passkey_url(passkey),
        reauthentication_token_url: user_reauthentication_url,
        reauthentication_token_field_name: field_name(:passkey, :reauthentication_token),
      },
      &block
    )
  end
end
