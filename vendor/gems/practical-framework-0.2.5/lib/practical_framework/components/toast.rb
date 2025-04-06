# frozen_string_literal: true

class PracticalFramework::Components::Toast< Phlex::HTML
  include FontAwesomeHelpers::ViewHelpers
  include Phlex::Rails::Helpers::ContentTag

  def initialize(type:, message:, icon:)
    @type = type
    @message = message
    @icon = icon
  end

  def view_template
    dialog(open: true, class: tokens(@type, 'default-size rounded cluster-default')) {
      div {
        unsafe_raw(@icon)
        whitespace
        span{ @message }
      }

      form(method: :dialog) {
        button(class: "squircle"){
          icon(style: 'fa-solid', name: 'circle-xmark')
        }
      }
    }
  end
end
