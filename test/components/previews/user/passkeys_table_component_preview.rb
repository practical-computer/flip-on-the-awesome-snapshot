# frozen_string_literal: true

class User::PasskeysTableComponentPreview < ViewComponent::Preview
  def default
    render(User::PasskeysTableComponent.new(passkeys: "passkeys"))
  end
end
