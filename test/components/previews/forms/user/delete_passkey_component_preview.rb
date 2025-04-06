# frozen_string_literal: true

class Forms::User::DeletePasskeyComponentPreview < ViewComponent::Preview
  def default
    render(Forms::User::DeletePasskeyComponent.new(passkey: "passkey"))
  end
end
