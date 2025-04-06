# frozen_string_literal: true

require "test_helper"

class PracticalViews::Form::ErrorListComponentTest < ViewComponentTestCase
  def test_component_renders_something_useful
    errors = ActiveModel::Errors.new(User.first)
    errors.add(:email, :blank)
    errors.add(:name, :too_long, count: 1000)
    render_inline(PracticalViews::Form::ErrorListComponent.new(errors: errors))

    errors.each do |error|
      assert_selector "ul li span", text: error.message
    end
  end
end
