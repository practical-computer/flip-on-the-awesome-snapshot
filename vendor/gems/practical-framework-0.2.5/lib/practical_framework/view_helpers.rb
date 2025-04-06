# frozen_string_literal: true

module PracticalFramework
  module ViewHelpers
    def double_quoted_text(text)
      "“#{text}”"
    end

    def single_quoted_text(text)
      "‘#{text}’"
    end

    def guided_translate(key, **options)
      new_options = options.reverse_merge(
        default: []
      )

      if key.start_with?(".")
        path_parts = controller_path.split("/")
        namespaced_versions = path_parts.each_with_index
                                        .map{|part, i| path_parts[0..i]}
                                        .map{|x| :"#{x.join(".")}#{key}"}

        guided_defaults = [
          namespaced_versions,
          key[1..].to_sym
        ].flatten

        new_options[:default] += guided_defaults
      end

      t(key, **new_options)
    end

    def auditing_time_tag(date_or_time)
      time_tag(date_or_time, date_or_time.to_formatted_s(:long), title: date_or_time.to_formatted_s(:iso8601))
    end

    def application_form_with(**options, &block)
      form = options[:model]
      final_options = options.reverse_merge(
        "local": false,
        "aria-describedby": dom_id(form.class, :generic_errors),
        "data": {
          type: :json,
        }, "builder": ApplicationFormBuilder,
        "class": "stack-compact"
      )

      return practical_form_with(**final_options, &block)
    end

    def id_selector(text)
      text = text.to_param if text.is_a?(GlobalID)
      "##{text}"
    end
  end
end
