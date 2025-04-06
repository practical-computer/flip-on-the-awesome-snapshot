# frozen_string_literal: true

class Navigation::QuickUserSettingsComponentPreview < ViewComponent::Preview
  def default
    render(Navigation::QuickUserSettingsComponent.new(current_user: User.first))
  end
end
