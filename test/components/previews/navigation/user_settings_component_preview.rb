# frozen_string_literal: true

class Navigation::UserSettingsComponentPreview < ViewComponent::Preview
  def default
    render_with_template(locals: {current_user: User.first})
  end
end
