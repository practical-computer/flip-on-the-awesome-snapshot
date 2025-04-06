# frozen_string_literal: true

class PracticalFramework::Components::ClosePopoverButton < PracticalFramework::Components::StandardButton
  def initialize(popover_dom_id:, icon:)
    super(
      title: nil,
      leading_icon: icon,
      type: :button,
      html_options: {
        popovertarget: popover_dom_id,
        popovertargetaction: "hide"
      }
    )
  end

  def view_template
    button(**@button_attributes){
      unsafe_raw(leading_icon)
    }
  end

  def default_button_classes
    ["squircle", "raised", "raised-labeling"]
  end
end