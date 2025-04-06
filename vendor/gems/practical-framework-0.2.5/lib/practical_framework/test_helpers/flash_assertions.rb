# frozen_string_literal: true

module PracticalFramework::TestHelpers::FlashAssertions
  def assert_flash_message(type:, message:, icon_name:)
    assert_equal message, flash[type][:message], flash
    assert_includes flash[type][:icon], icon_name, flash
  end
end
