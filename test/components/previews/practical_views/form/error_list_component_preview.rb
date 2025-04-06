# frozen_string_literal: true

class PracticalViews::Form::ErrorListComponentPreview < ViewComponent::Preview
  def default
    errors = ActiveModel::Errors.new(User.first)
    errors.add(:email, :blank)
    errors.add(:name, :too_long, count: 1000)
    render(PracticalViews::Form::ErrorListComponent.new(errors: errors))
  end
end
