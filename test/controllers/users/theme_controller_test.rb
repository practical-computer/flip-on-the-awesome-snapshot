# frozen_string_literal: true

require "test_helper"

class Users::ThemeControllerTest < ActionDispatch::IntegrationTest
  def assert_update_policies_applied(user:, &block)
    assert_authorized_to(:manage?, user, with: UserPolicy, &block)
  end

  test "update: updates the current_user's theme" do
    user = users.organization_1_owner
    sign_in(user)

    theme = "dark"

    assert_not_equal theme, user.theme

    params = {
      user_theme: {
        theme: theme
      }
    }

    assert_update_policies_applied(user: user) do
      patch user_update_theme_url, params: params
    end

    assert_redirected_to edit_user_registration_url(user)

    user.reload

    assert_equal true, user.dark_theme?
  end

  test "update: does not update non-theme values" do
    user = users.organization_1_owner
    sign_in(user)

    old_email = user.email

    theme = "dark"
    email = Faker::Internet.email

    assert_equal old_email, user.email

    params = {
      user_theme: {
        theme: theme,
        email: email
      }
    }

    assert_update_policies_applied(user: user) do
      patch user_update_theme_url, params: params
    end

    assert_redirected_to edit_user_registration_url(user)

    user.reload

    assert_equal old_email, user.email
  end
end
