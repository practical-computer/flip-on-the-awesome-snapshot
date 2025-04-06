# frozen_string_literal: true

class PracticalFramework::Components::ButtonTo < PracticalFramework::Components::StandardButton
  include Phlex::Rails::Helpers::ButtonTo

  attr_accessor :name, :options, :html_options

  def initialize(name = nil, options = nil, html_options = nil)
    self.name = name
    self.options = options
    self.html_options = html_options
    if options.kind_of?(Hash)
      options.merge!(
        class: all_button_classes(extra_classes: options[:class]),
      )
    end
  end

  def view_template
    if block_given?
      button_to(name, options, html_options) do
        yield
      end
    else
      button_to(name, options, html_options)
    end
  end
end