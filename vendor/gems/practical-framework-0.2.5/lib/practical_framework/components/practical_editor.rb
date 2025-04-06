# frozen_string_literal: true

class PracticalFramework::Components::PracticalEditor < Phlex::HTML
  include FontAwesomeHelpers::ViewHelpers
  include Phlex::Rails::Helpers::ContentTag
  include Phlex::Rails::Helpers::ContentFor

  attr_accessor :input_id, :aria_describedby_id, :direct_upload_url
  register_element :practical_editor

  def initialize(input_id:, aria_describedby_id:, direct_upload_url:, extra_classes: nil, html_options: {})
    @input_id = input_id
    @classes = extra_classes
    @direct_upload_url = direct_upload_url
    @html_options = html_options
  end

  def view_template
    practical_editor(**final_editor_options) {
      toolbar_slots
      editor_slot
    }
  end

  def toolbar_slots
    span(slot: "bold-icon"){ cached_icon(symbol_name: 'bold-icon', style: 'fa-solid', name: 'bold') }
    span(slot: "italics-icon"){ cached_icon(symbol_name: 'italics-icon', style: 'fa-solid', name: 'italic') }
    span(slot: "strike-icon"){ cached_icon(symbol_name: 'strike-icon', style: 'fa-duotone', name: 'strikethrough') }
    span(slot: "link-icon"){ cached_icon(symbol_name: 'link-icon', style: 'fa-solid', name: 'link') }

    span(slot: "heading-icon"){ cached_icon(symbol_name: 'heading-icon', style: 'fa-solid', name: 'h1') }
    span(slot: "blockquote-icon"){
      cached_icon(symbol_name: 'blockquote-icon', style: 'fa-duotone', name: 'block-quote')
    }
    span(slot: "code-block-icon"){ cached_icon(symbol_name: 'code-block-icon', style: 'fa-solid', name: 'code') }

    span(slot: "bullet-list-icon"){ cached_icon(symbol_name: 'bullet-list-icon', style: 'fa-solid', name: 'list-ul') }
    span(slot: "ordered-list-icon"){ cached_icon(symbol_name: 'ordered-list-icon', style: 'fa-solid', name: 'list-ol') }

    span(slot: "increase-indentation"){
      cached_icon(symbol_name: 'increase-indentation', style: 'fa-duotone', name: 'indent')
    }
    span(slot: "decrease-indentation"){
      cached_icon(symbol_name: 'decrease-indentation', style: 'fa-duotone', name: 'outdent')
    }

    span(slot: "attach-files-icon"){
      cached_icon(symbol_name: 'attach-files-icon', style: 'fa-solid', name: 'paperclip')
    }

    span(slot: "undo-icon"){ cached_icon(symbol_name: 'undo-icon', style: 'fa-solid', name: 'undo') }
    span(slot: "redo-icon"){ cached_icon(symbol_name: 'redo-icon', style: 'fa-solid', name: 'redo') }
  end

  def editor_slot
    div("slot": :editor, "aria-describedby": aria_describedby_id, "class": "stack-compact")
  end

  def final_editor_options
    @html_options.reverse_merge(
      "input": input_id,
      "serializer": :json,
      "class": final_editor_classes,
      "data-direct-upload-url": direct_upload_url
    )
  end

  def final_editor_classes
    tokens(["box-compact", "raised", "rounded"] + Array.wrap(@classes))
  end
end