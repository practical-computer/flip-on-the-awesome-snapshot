# frozen_string_literal: true

module PracticalFramework
  module ViewHelpers
    module IconHelpers
      def passkey_icon
        icon(style: :"fa-kit", name: :passkey)
      end

      def emergency_passkey_registration_icon
        icon(style: 'fa-duotone', name: 'light-emergency-on', html_options: {
          style: "--fa-secondary-color: var(--danger-color-05); --fa-secondary-opacity: 0.9;"
        })
      end

      def signin_icon
        icon(style: 'fa-duotone', name: 'person-to-portal', html_options: {
          style: "--fa-secondary-color: var(--primary-accent-color-05); --fa-secondary-opacity: 0.9;"
        })
      end

      def info_icon
        icon(style: 'fa-duotone', name: 'circle-info')
      end

      def signup_icon
        icon(style: "fa-duotone fa-fw", name: "user-plus")
      end

      def user_name_icon
        icon(style: 'fa-solid fa-fw', name: 'hand-wave')
      end

      def email_address_icon
        icon(style: 'fa-solid fa-fw', name: 'at')
      end

      def send_email_icon
        icon(style: 'fa-duotone', name: "paper-plane")
      end

      def sent_email_icon
        icon(style: 'fa-duotone', name: 'envelope-dot')
      end

      def link_icon
        icon(style: 'fa-duotone', name: 'link')
      end

      def sign_out_icon
        icon(style: "fa-duotone fa-fw", name: "person-from-portal")
      end

      def save_icon
        cached_icon(symbol_name: 'save', style: 'fa-duotone fa-fw', name: 'floppy-disk')
      end

      def filters_icon
        cached_icon(symbol_name: 'filters', style: 'fa-duotone fa-fw', name: 'filters')
      end

      def apply_filters_icon
        cached_icon(symbol_name: 'apply-filter', style: 'fa-solid fa-fw', name: 'filter')
      end

      def notes_icon
        cached_icon(symbol_name: 'note', style: 'fa-duotone fa-fw', name: 'note')
      end

      alias_method :note_icon, :notes_icon

      def add_note_icon
        icon(style: 'fa-kit fa-fw', name: "solid-note-circle-plus")
      end

      def edit_note_icon
        icon(style: 'fa-kit fa-fw', name: "solid-note-pen")
      end

      def delete_note_icon
        icon(style: 'fa-kit fa-fw', name: "solid-note-slash")
      end

      def user_icon
        cached_icon(symbol_name: 'user', style: 'fa-duotone fa-fw', name: 'user')
      end

      def details_icon
        icon(style: 'fa-solid fa-fw', name: 'chevron-down', html_options: {class: 'details-marker'})
      end

      def dialog_close_icon
        cached_icon(symbol_name: "dialog-close-icon", style: 'fa-solid fa-fw', name: "xmark")
      end

      def ascending_icon
        cached_icon(symbol_name: "ascending-icon", style: 'fa-duotone fa-fw', name: "sort-up")
      end

      def descending_icon
        cached_icon(symbol_name: "descending-icon", style: 'fa-duotone fa-fw', name: "sort-down")
      end

      def sort_icon
        cached_icon(symbol_name: "sort-icon", style: 'fa-regular fa-fw', name: "sort")
      end

      def theming_icon
        icon(style: 'fa-duotone fa-fw', name: 'spray-can-sparkles')
      end

      def theme_icon
        icon(style: 'fa-duotone fa-fw', name: 'swatchbook')
      end

      def share_icon
        icon(style: 'fa-duotone fa-fw', name: 'share-from-square')
      end
    end
  end
end