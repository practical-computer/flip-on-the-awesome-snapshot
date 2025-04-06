# frozen_string_literal: true

class PracticalViews::Form::ErrorListItemComponentPreview < ViewComponent::Preview
  def default
    error = ActiveModel::Error.new(User.first, :email, :too_short, count: 5)
    render(PracticalViews::Form::ErrorListItemComponent.new(error: error))
  end
end
