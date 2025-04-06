# frozen_string_literal: true

class Forms::SigninFormComponentPreview < ViewComponent::Preview
  def default
    model = User.first
    render(Forms::SigninFormComponent.new(
      model: model,
      as: :user,
      url: "url",
      challenge_url: "challenge_url",
      credential_field_name: "credential_field_name"
    ))
  end
end
