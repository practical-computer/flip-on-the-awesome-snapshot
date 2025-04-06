# frozen_string_literal: true

class PracticalFramework::Components::TabbedDialogFrame < PracticalFramework::Components::TabbedFrame
  def frame_classes
    classes(:"tabbed-frame", :"box-compact", :"with-sidebar")
  end
end
