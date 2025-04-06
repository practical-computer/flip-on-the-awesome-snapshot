# frozen_string_literal: true

class Forms::User::ProfileFormComponentPreview < ViewComponent::Preview
  def default
    render(Forms::User::ProfileFormComponent.new(user: "user"))
  end
end
