# frozen_string_literal: true

# https://github.com/Daniel-N-Huss/tailwind_form_builder_example/blob/main/app/lib/form_builders/tailwind_form_builder.rb
class PracticalFramework::FormBuilders::Base < ActionView::Helpers::FormBuilder
  include Phlex::Helpers
  attr_reader :template
  class_attribute :text_field_helpers,
                  default: field_helpers - [:label,
                                            :check_box,
                                            :radio_button,
                                            :fields_for,
                                            :fields,
                                            :hidden_field,
                                            :file_field
                                           ]

  TEXT_FIELD_CLASSES = ["rounded", "raised", "raised-labeling"].freeze
  SELECT_FIELD_CLASSES = TEXT_FIELD_CLASSES
  INPUT_WRAPPER_CLASSES = ["stack-extra-compact", "input-wrapper"].freeze
  FIELDSET_CLASSES = ["rounded", "stack-compact", "box-compact"].freeze
  LEGEND_CLASSES = ["squircle"].freeze
  FALLBACK_ERROR_SECTION_CLASSES = ["squircle",
                                    "error",
                                    "fallback-error-section",
                                    "stack-extra-compact",
                                    "box-compact"
                                    ].freeze

  text_field_helpers.each do |field_method|
    class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
      def #{field_method}(method, options = {})
        if options.delete(:practical_framework_processed)
          super
        else
          text_like_field(#{field_method.inspect}, method, options)
        end
      end
    RUBY_EVAL
  end

  class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
    def select(method, choices, options = {}, html_options={})
      if options.delete(:practical_framework_processed)
        super
      else
        practical_select_field(method, choices, options, html_options)
      end
    end
  RUBY_EVAL

  def practical_editor_field(object_method, direct_upload_url:, options: {})
    custom_opts, opts = partition_custom_opts(options)

    classes = apply_classes(
      default_classes: TEXT_FIELD_CLASSES,
      custom_classes: custom_opts[:class]
    )

    data = apply_data_properties(
      object_method: object_method,
      custom_data: custom_opts[:data]
    )

    finalized_options = {
      "class": classes,
      "data": data,
      "aria-describedby": field_errors_id(object_method),
      "aria-invalid": errors_for(object_method).present?,
      "id": field_id(object_method)
    }.compact.merge(opts).merge(practical_framework_processed: true)

    @template.safe_join([
      hidden_field(object_method, **finalized_options),
      @template.render(PracticalFramework::Components::PracticalEditor.new(
        input_id: finalized_options[:id],
        aria_describedby_id: finalized_options["aria-describedby"],
        direct_upload_url: direct_upload_url
      ))
    ])
  end

  def required_radio_collection_wrapper(object_method, options = {}, &block)
    finalized_options = {
      "fieldset": field_id(object_method),
      "field-name": field_name(object_method),
      "errors-element": field_id(object_method, :errors),
      "errors-element-aria": field_id(object_method, :errors_aria),
    }.compact.merge(options)

    @template.content_tag(:"required-radio-collection", finalized_options, &block)
  end

  def text_like_field(field_method, object_method, options = {})
    custom_opts, opts = partition_custom_opts(options)

    classes = apply_classes(
      default_classes: TEXT_FIELD_CLASSES,
      custom_classes: custom_opts[:class]
    )

    data = apply_data_properties(
      object_method: object_method,
      custom_data: custom_opts[:data]
    )

    finalized_options = {
      "class": classes,
      "data": data,
      "aria-describedby": field_errors_id(object_method),
      "aria-invalid": errors_for(object_method).present?,
    }.compact.merge(opts).merge(practical_framework_processed: true)

    send(field_method, object_method, finalized_options)
  end

  def practical_select_field(object_method, choices = nil, options = {}, html_options = {})
    custom_opts, html_opts = partition_custom_opts(html_options)

    classes = apply_classes(
      default_classes: SELECT_FIELD_CLASSES,
      custom_classes: custom_opts[:class],
      remove_classes: custom_opts[:remove_classes]
    )

    data = apply_data_properties(
      object_method: object_method,
      custom_data: custom_opts[:data]
    )

    finalized_html_options = {
      "class": classes,
      "data": data,
      "aria-describedby": field_errors_id(object_method),
      "aria-invalid": errors_for(object_method).present?,
    }.compact.merge(html_opts)

    finalized_options = options.merge(practical_framework_processed: true)

    send(:select, object_method, choices, finalized_options, finalized_html_options)
  end

  def fieldset(options = {}, &block)
    finalized_options = build_finalized_options(options)
    @template.field_set_tag(nil, finalized_options, &block)
  end

  def legend(options = {}, &block)
    finalized_options = build_finalized_options(options)
    @template.content_tag(:legend, finalized_options, &block)
  end

  def build_finalized_options(options)
    custom_opts, opts = partition_custom_opts(options)

    classes = apply_classes(
      default_classes: LEGEND_CLASSES,
      custom_classes: custom_opts[:class],
      remove_classes: custom_opts[:remove_classes]
    )

    return { class: classes }.compact.merge(opts)
  end

  def radio_collection(field_method:, options:)
    collection_radio_buttons(field_method, options, :value, :title) do |collection_builder|
      item_id = field_id(field_method, collection_builder.value)
      @template.render PracticalFramework::Components::RadioInput.new(id: item_id) do |radio_input|
        radio_input.toggle_wrapper do
          collection_builder.radio_button(id: radio_input.id, class: radio_input.input_classes) +
          collection_builder.object.icon
        end

        radio_input.field_label(title: collection_builder.object.title,
                                description: collection_builder.object.description)
      end
    end
  end

  def check_box_collection(field_method:, options:, collection_check_boxes_options: {})
    collection_check_boxes(field_method,
                           options,
                           :value,
                           :title,
                           collection_check_boxes_options
    ) do |collection_builder|
      item_id = field_id(field_method, collection_builder.value)
      @template.render PracticalFramework::Components::CheckboxInput.new(id: item_id) do |checkbox_input|
        checkbox_input.toggle_wrapper do
          collection_builder.check_box(id: checkbox_input.id, class: checkbox_input.input_classes) +
          @template.icon(style: 'fa-solid', name: 'check', html_options: {class: 'fa-fw'}) +
          @template.icon(style: 'fa-solid', name: 'minus', html_options: {class: 'fa-fw indeterminate-icon'})
        end

        checkbox_input.field_label(title: collection_builder.object.title,
                                   description: collection_builder.object.description
                                  )
      end
    end
  end

  def field_errors_id(object_method)
    field_id(object_method, :errors)
  end

  def field_errors(object_method, options = {})
    custom_opts, opts = partition_custom_opts(options)
    classes = ["error"]
    errors = errors_for(object_method)

    if errors.blank?
      classes << ["no-server-errors"]
    end

    classes = apply_classes(
      default_classes: classes,
      custom_classes: custom_opts[:class],
      remove_classes: custom_opts[:remove_classes]
    )

    id = field_errors_id(object_method)

    finalized_options = {
      id: id,
      class: classes
    }.compact.merge(opts)

    return label(object_method, nil, finalized_options) do
      if errors.blank?
        error_list([])
      else
        error_list(errors)
      end
    end
  end

  def fallback_error_section(blurb_key: :"practical_framework.forms.generic_error_blurb", options: {})
    custom_opts, opts = partition_custom_opts(options)

    if @object.errors.present?
      remaining_errors = @object.errors.reject{|error| error.options[:has_been_rendered] }
    else
      remaining_errors = []
    end

    blurb = @template.translate(blurb_key, raise: true)

    classes = apply_classes(
      default_classes: FALLBACK_ERROR_SECTION_CLASSES,
      custom_classes: custom_opts[:class],
      remove_classes: custom_opts[:remove_classes]
    )

    finalized_options = {
      class: classes,
    }.compact.merge(opts)

    @template.content_tag(:section, finalized_options) do
      @template.content_tag(:header) do
        @template.content_tag(:strong, blurb)
      end +
      error_list(remaining_errors)
    end
  end

  def error_list(errors)
    @template.content_tag(:ul, class: 'fa-ul') do
      @template.safe_join(errors.map{|error| error_list_item(error: error) })
    end
  end

  def error_list_item(error:)
    error.options[:has_been_rendered] = true
    @template.content_tag(:li, data: {"error-type": error.type}) do
      @template.content_tag(:span, class: "fa-li") do
        @template.cached_icon(symbol_name: 'error-list-icon', style: 'fa-solid', name: 'circle-exclamation')
      end +
      @template.content_tag(:span, error.message)
    end
  end

  def input_wrapper(options = {}, &block)
    custom_opts, opts = partition_custom_opts(options)

    classes = apply_classes(
      default_classes: INPUT_WRAPPER_CLASSES,
      custom_classes: custom_opts[:class],
      remove_classes: custom_opts[:remove_classes]
    )

    finalized_options = {
      class: classes
    }.compact.merge(opts)

    @template.content_tag(:section, finalized_options, &block)
  end

  CUSTOM_OPTS = [:class, :data, :remove_classes].freeze
  def partition_custom_opts(opts)
    opts.partition { |k, v| CUSTOM_OPTS.include?(k) }.map(&:to_h)
  end

  def apply_classes(default_classes:, custom_classes:, remove_classes: [])
    final_class_set = (
      Array.wrap(default_classes) + Array.wrap(custom_classes)
    ) - Array.wrap(remove_classes)
    tokens(final_class_set)
  end

  def apply_data_properties(object_method:, custom_data:)
    server_side_errors = errors_for(object_method).present?
    custom_data ||= {}

    if server_side_errors.present?
      return {"server-side-errors": server_side_errors}.merge(custom_data)
    else
      return custom_data
    end
  end

  def errors_for(object_method)
    return unless @object.present? && object_method.present?
    @object.errors.group_by_attribute[object_method]
  end

  def self.build_error_json(model:, helpers:)
    return model.errors.map do |error|
      error_container_id = error_container_id(model: model, error: error, helpers: helpers)
      element_id = error_element_id(model: model, error: error, helpers: helpers)

      {
        container_id: error_container_id,
        element_id: element_id,
        message: error.message
      }
    end
  end

  def self.error_container_id(model:, error:, helpers:)
    if error.options[:error_container_id].present?
      return error.options[:error_container_id]
    else
      attribute_name_parts = error.attribute.to_s.split(".")
      return helpers.field_id(model, *attribute_name_parts, :errors)
    end
  end

  def self.error_element_id(model:, error:, helpers:)
    if error.options[:element_id].present?
      return error.options[:element_id]
    else
      attribute_name_parts = error.attribute.to_s.split(".")
      return helpers.field_id(model, *attribute_name_parts)
    end
  end
end
