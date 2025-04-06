# frozen_string_literal: true

require "test_helper"

class PatchedFlashHelpersTest < ActiveSupport::TestCase
  class TestClass
    include PatchedFlashHelpers

    def using_web_awesome?
      Flipper.enabled?(:web_awesome)
    end

    def helpers
      ApplicationController.helpers
    end
  end

  def helpers
    ApplicationController.helpers
  end

  test "no web_awesome" do
    skip "Running Web Awesome" if WebAwesomeTest.web_awesome?
    assert_equal false, Flipper.enabled?(:web_awesome)
    assert_equal helpers.icon(style: 'fa-duotone', name: 'circle-check'), TestClass.new.default_success_icon
    assert_equal helpers.icon(style: 'fa-duotone', name: 'circle-info'), TestClass.new.default_notice_icon
    assert_equal helpers.icon(style: 'fa-duotone', name: 'triangle-exclamation'), TestClass.new.default_alert_icon
  end

  test "web_awesome" do
    Flipper.enable(:web_awesome)
    assert_equal helpers.icon_set.success_icon.name, TestClass.new.default_success_icon.name
    assert_equal helpers.icon_set.info_icon.name, TestClass.new.default_notice_icon.name
    assert_equal helpers.icon_set.alert_icon.name, TestClass.new.default_alert_icon.name
  end
end