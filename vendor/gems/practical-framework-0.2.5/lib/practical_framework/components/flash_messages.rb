# frozen_string_literal: true

class PracticalFramework::Components::FlashMessages < Phlex::HTML
  include FontAwesomeHelpers::ViewHelpers
  include Phlex::Rails::Helpers::ContentTag

  attr_accessor :flash

  def initialize(flash:)
    self.flash = flash
  end

  def view_template
    aside(class: tokens('notification-messages stack-compact box-compact')) {
      alert_message
      notice_message
      success_message
    }
  end

  def success_message
    return render_message(type: :success,
                          data: flash[:success],
                          default_icon: helpers.icon(style: 'fa-duotone', name: 'circle-check')
                         )
  end

  def notice_message
    return render_message(type: :notice,
                          data: flash.notice,
                          default_icon: helpers.icon(style: 'fa-duotone', name: 'circle-info')
                         )
  end

  def alert_message
    return render_message(type: :alert,
                          data: flash.alert,
                          default_icon: helpers.icon(style: 'fa-duotone', name: 'triangle-exclamation')
                         )
  end

  def render_message(type:, data:, default_icon:)
    return nil if data.nil?

    case data
    when String
      render PracticalFramework::Components::Toast.new(type: type,
                                                       message: data,
                                                       icon: default_icon
            )
    when Hash
      data = data.with_indifferent_access
      render PracticalFramework::Components::Toast.new(type: type, message: data[:message], icon: data[:icon])
    end
  end
end
