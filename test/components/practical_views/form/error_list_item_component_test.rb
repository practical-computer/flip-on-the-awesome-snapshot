# frozen_string_literal: true

require "test_helper"

class PracticalViews::Form::ErrorListItemComponentTest < ViewComponentTestCase
  def test_component_renders_something_useful
    error = ActiveModel::Error.new(User.first, :email, :too_short, count: 5)
    render_inline(PracticalViews::Form::ErrorListItemComponent.new(error: error))

    assert_selector("li span", text: error.message)
    assert_selector("li[data-error-type='#{error.type}']")
  end
end
