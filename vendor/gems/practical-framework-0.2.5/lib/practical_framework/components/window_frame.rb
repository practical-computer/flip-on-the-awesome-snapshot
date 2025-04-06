# frozen_string_literal: true

class PracticalFramework::Components::WindowFrame < PracticalFramework::Components::TabbedFrame
  def initialize(sections:, panels:, use_seven_minute_tabs: false)
    super
  end

  def contents_container(**args, &block)
    main(**args, &block)
  end

  def frame_classes
    classes(:"tabbed-frame", :"box-compact", :"with-sidebar", :"window-frame")
  end
end
