# frozen_string_literal: true

class Forms::AddPasskeyFormComponent < ApplicationComponent
  attr_accessor :scope, :url, :form_id, :reauthentication_challenge_url, :reauthentication_token_url, :challenge_url

  def initialize(scope:, url:, form_id:, reauthentication_challenge_url:, reauthentication_token_url:, challenge_url:)
    @scope = scope
    @url = url
    @form_id = form_id
    @reauthentication_challenge_url = reauthentication_challenge_url
    @reauthentication_token_url = reauthentication_token_url
    @challenge_url = challenge_url
  end

  def generic_errors_id
    [form_id, :generic_errors].map(&:to_s).join("-")
  end

  def form_wrapper(&block)
    helpers.webawesome_form_with(
      "scope": scope,
      "url": url,
      "local": false,
      "id": form_id,
      "aria-describedby": generic_errors_id,
      "data": {
        type: :json,
        type: :json,
        reauthentication_challenge_url: reauthentication_challenge_url,
        reauthentication_token_url: reauthentication_token_url,
        reauthentication_token_field_name:  field_name(scope, :reauthentication_token),
        challenge_url: challenge_url,
        credential_field_name: field_name(scope, :credential)
      },
      &block
    )
  end
end
