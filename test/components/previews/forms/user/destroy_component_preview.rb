# frozen_string_literal: true

class Forms::User::DestroyComponentPreview < ViewComponent::Preview
  def default
    render(Forms::User::DestroyComponent.new(user: "user"))
  end
end
