# frozen_string_literal: true

class PracticalViews::FormBuilders::WebAwesome < ActionView::Helpers::FormBuilder
  include PracticalViews::ElementHelper
  attr_reader :template, :object

  def fieldset(options = {}, &block)
    finalized_options = mix({class: 'wa-stack'}, options)
    template.tag.fieldset(**finalized_options, &block)
  end

  def legend(options = {}, &block)
    finalized_options = mix({}, options)
    template.tag.legend(**finalized_options, &block)
  end

  def fieldset_title(icon:, title:)
    template.render(PracticalViews::Form::FieldsetTitleComponent.new) do |component|
      component.with_icon {
        template.render icon
      }

      title
    end
  end

  def field_title(icon:, title:)
    template.render(PracticalViews::Form::FieldTitleComponent.new) do |component|
      component.with_icon {
        template.render icon
      }

      title
    end
  end

  def input_component(object_method, label_options: {}, &block)
    template.render(PracticalViews::Form::InputComponent.new(
      f: self,
      object_method: object_method,
      label_options: label_options
    ), &block)
  end

  def practical_editor_field(object_method:, direct_upload_url:, hidden_input_options: {}, options: {})
    aria_describedby_id = field_errors_id(object_method)
    input_id = field_id(object_method)

    finalized_hidden_input_options = mix({
      "aria-describedby": aria_describedby_id,
      "aria-invalid": errors_for(object_method).present?,
      "id": input_id,
    }, hidden_input_options)

    template.safe_join([
      self.hidden_field(object_method, **finalized_hidden_input_options),
      template.render(PracticalViews::Form::PracticalEditorComponent.new(
        input_id: input_id,
        aria_describedby_id: aria_describedby_id,
        direct_upload_url: direct_upload_url,
        options: options
      ))
    ])
  end

  def button_component(options = {}, &block)
    template.render(PracticalViews::ButtonComponent.new(**options), &block)
  end

  def check_box_collection(field_method:, options:, collection_check_boxes_options: {})
    collection_check_boxes(field_method,
                           options,
                           :value,
                           :title,
                           collection_check_boxes_options
    ) do |collection_builder|
      collection_builder.label(class: "wa-flank") do
        template.safe_join([
          collection_builder.checkbox,
          template.render(PracticalViews::Form::OptionLabelComponent.new) do |component|
            component.with_title do
              template.icon_text(
                icon: collection_builder.object.icon,
                text: collection_builder.object.title
              )
            end

            component.with_description{ collection_builder.object.description }
          end
        ])
      end
    end
  end

  def radio_collection(field_method:, options:, collection_check_boxes_options: {})
    collection_radio_buttons(field_method,
                           options,
                           :value,
                           :title,
                           collection_check_boxes_options
    ) do |collection_builder|
      collection_builder.label(class: "wa-flank") do
        template.safe_join([
          collection_builder.radio_button,
          template.render(PracticalViews::Form::OptionLabelComponent.new) do |component|
            component.with_title do
              template.icon_text(
                icon: collection_builder.object.icon,
                text: collection_builder.object.title
              )
            end

            component.with_description{ collection_builder.object.description }
          end
        ])
      end
    end
  end

  def required_radio_collection_wrapper(object_method, options = {}, &block)
    template.render(PracticalViews::Form::RequiredRadioCollectionWrapperComponent.new(
      f: self,
      object_method: object_method,
      options: options
    ), &block)
  end

  def field_errors(object_method, options = {})
    template.render PracticalViews::Form::FieldErrorsComponent.new(
      f: self,
      object_method: object_method,
      options: options
    )
  end

  def fallback_error_section(blurb_key: :"practical_framework.forms.generic_error_blurb", options: {})
    template.render PracticalViews::Form::FallbackErrorsSectionComponent.new(
      f: self,
      blurb: template.translate(blurb_key, raise: true),
      options: options
    )
  end

  def errors_for(object_method)
    return unless object.present? && object_method.present?
    object.errors.group_by_attribute[object_method]
  end

  def field_errors_id(object_method)
    field_id(object_method, :errors)
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