# frozen_string_literal: true

class Forms::AddPasskeyFormComponentPreview < ViewComponent::Preview
  def default
    render(Forms::AddPasskeyFormComponent.new(scope: "scope", url: "url", reauthentication_challenge_url: "reauthentication_challenge_url", reauthentication_token_url: "reauthentication_token_url", challenge_url: "challenge_url"))
  end
end
