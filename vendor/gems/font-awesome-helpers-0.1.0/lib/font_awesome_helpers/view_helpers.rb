module FontAwesomeHelpers
  module ViewHelpers
    def icon(style:, name:, text: nil, html_options: {})
      content_class = "#{style} fa-#{name}"
      content_class << " #{html_options[:class]}" if html_options.key?(:class)
      html_options[:class] = content_class
      html_options['aria-hidden'] ||= true

      html = content_tag(:i, nil, html_options)
      html << ' ' << text.to_s unless text.blank?
      html
    end

    def cached_icon(symbol_name:, style:, name:, text:nil, html_options: {})
      symbol_name = symbol_name.to_sym

      unless fontawesome_symbol_cache.include?(symbol_name)
        html_options[:data] ||= {}
        html_options[:data][:"fa-symbol"] = symbol_name

        generated_icon = icon(style: style, name: name, text: text, html_options: html_options)
        content_for(:cached_fontawesome_symbols, generated_icon)
        fontawesome_symbol_cache.add(symbol_name)
      end


      svg_use_icon(href: "##{symbol_name}", html_options: {class: :icon})
    end

    def svg_use_icon(href:, html_options:)
      content_tag(:svg, html_options) do
        content_tag(:use, nil, href: href)
      end
    end

    def fontawesome_symbol_cache
      @fontawesome_symbol_cache ||= Set.new
    end

    def cached_fontawesome_symbols
      content_for(:cached_fontawesome_symbols)
    end
  end
end
