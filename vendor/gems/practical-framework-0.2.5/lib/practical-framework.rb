# frozen_string_literal: true

require 'phlex-rails'
require 'loaf'
require 'pagy'
require 'font-awesome-helpers'

module PracticalFramework
  class Error < StandardError; end
  # Your code goes here...

  module App
  end

  module Forms
  end

  module FormBuilders
  end

  module Loaders
  end

  module RelationBuilders
  end

  module Components
    module Datatables
    end

    module Forms
    end

    module Util
    end
  end
end

require_relative "practical_framework/version"
require_relative "practical_framework/railtie"
require_relative "practical_framework/theme_options"
require_relative "practical_framework/view_helpers"
require_relative "practical_framework/duration_parser"
require_relative "practical_framework/form_builders/base"
require_relative "practical_framework/components/wrapped_toggle"
require_relative "practical_framework/components/breadcrumbs"
require_relative "practical_framework/components/card_button"
require_relative "practical_framework/components/checkbox_input"
require_relative "practical_framework/components/pagination"
require_relative "practical_framework/components/radio_input"
require_relative "practical_framework/components/standard_button"
require_relative "practical_framework/components/tabbed_frame"
require_relative "practical_framework/components/tabbed_dialog_frame"
require_relative "practical_framework/components/window_frame"
require_relative "practical_framework/components/toast"
require_relative "practical_framework/components/flash_messages"
require_relative "practical_framework/components/practical_editor"
require_relative "practical_framework/components/button_to"
require_relative "practical_framework/components/close_popover_button"
require_relative "practical_framework/components/popover_button"
require_relative "practical_framework/components/tiptap_document"
require_relative "practical_framework/components/icon_for_file_extension"
require_relative "practical_framework/components/share_link"
require_relative "practical_framework/components/time_tag"
require_relative "practical_framework/components/datatables/sort_link"
require_relative "practical_framework/components/datatables/filter_wrapper_component"
require_relative "practical_framework/components/util/clear_on_reset_component"

require_relative "practical_framework/components/forms/add_passkey"
require_relative "practical_framework/components/forms/signin"

require_relative "practical_framework/loaders/base"
require_relative "practical_framework/relation_builders/base"

require_relative "practical_framework/forms/datatable_form"
require_relative "practical_framework/forms/collection_option"

require_relative "practical_framework/shrine_extensions"

require_relative "practical_framework/view_helpers/icon_helpers"
require_relative "practical_framework/view_helpers/honeybadger_helpers"
require_relative "practical_framework/view_helpers/theme_helpers"

require_relative "practical_framework/controllers/create_user_from_invitations"
require_relative "practical_framework/controllers/emergency_passkey_registrations"
require_relative "practical_framework/controllers/error_response"
require_relative "practical_framework/controllers/flash_helpers"
require_relative "practical_framework/controllers/json_redirection"
require_relative "practical_framework/controllers/translation_helpers"
require_relative "practical_framework/controllers/web_authn_debug_context"

require_relative 'practical_framework/honeybadger_semantic_logger_appender'