# frozen_string_literal: true

class Forms::User::ThemeFormComponentPreview < ViewComponent::Preview
  def default
    render(Forms::User::ThemeFormComponent.new(user: "user"))
  end
end
