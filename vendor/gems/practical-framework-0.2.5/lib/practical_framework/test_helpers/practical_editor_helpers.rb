# frozen_string_literal: true

module PracticalFramework::TestHelpers::PracticalEditorHelpers
  def type_into_editor(container_element:, keys:)
    container_element.find('practical-editor [slot="editor"]').send_keys(keys)
  end
end