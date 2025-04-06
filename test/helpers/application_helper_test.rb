# frozen_string_literal: true

require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "initials" do
    assert_equal "WA", initials(name: "Web Awesome")
    assert_equal "WA", initials(name: "Web Awesome Library")
    assert_equal "WE", initials(name: "Web")
    assert_equal "WE", initials(name: "web")
    assert_equal "", initials(name: "")
  end
end