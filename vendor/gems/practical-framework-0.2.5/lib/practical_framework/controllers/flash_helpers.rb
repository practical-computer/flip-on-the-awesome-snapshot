# frozen_string_literal: true

module PracticalFramework
  module Controllers
    module FlashHelpers
      extend ActiveSupport::Concern

      included do
        add_flash_types :success
      end

      def flash_message_with_icon(message:, icon:)
        {message: message, icon: icon}
      end

      def flash_notice_with_icon(message:, icon: default_notice_icon)
        flash_message_with_icon(message: message, icon: icon)
      end

      def flash_alert_with_icon(message:, icon: default_alert_icon)
        flash_message_with_icon(message: message, icon: icon)
      end

      def flash_success_with_icon(message:, icon: default_success_icon)
        flash_message_with_icon(message: message, icon: icon)
      end

      def default_notice_icon
        helpers.icon(style: 'fa-duotone', name: 'circle-info')
      end

      def default_alert_icon
        helpers.icon(style: 'fa-duotone', name: 'triangle-exclamation')
      end

      def default_success_icon
        helpers.icon(style: 'fa-duotone', name: 'circle-check')
      end
    end
  end
end
