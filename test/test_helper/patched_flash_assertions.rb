# frozen_string_literal: true

module PatchedFlashAssertions
  def assert_flash_message(type:, message:, icon_name:)
    assert_equal message, flash[type][:message], flash
    cleaned_up_icon_name = icon_name.delete_prefix("fa-")
    assert_includes flash[type][:icon].name.to_s, cleaned_up_icon_name, flash
  end
end