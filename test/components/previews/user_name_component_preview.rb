# frozen_string_literal: true

class UserNameComponentPreview < ViewComponent::Preview
  def default
    render(UserNameComponent.new(user: User.first))
  end
end
