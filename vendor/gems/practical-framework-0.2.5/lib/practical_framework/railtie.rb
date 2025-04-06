# frozen_string_literal: true

module PracticalFramework
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load 'tasks/practical_framework/coverage_report.rake'
      load 'tasks/practical_framework/utility.rake'
    end

    # Hopefully can be removed in the future: https://github.com/rails/rails/issues/39522
    module PracticalFrameworkFormBuilderActiveSupportExtension
      def practical_form_with(**args, &block)
        original_field_error_proc = ::ActionView::Base.field_error_proc
        ::ActionView::Base.field_error_proc = ->(html_tag, instance) { html_tag }
        content_tag(:"practical-framework-error-handling") do
          form_with(**args, &block)
        end
      ensure
        ::ActionView::Base.field_error_proc = original_field_error_proc
      end
    end

    def self.config_rubocop_after_generator(config:)
      config.generators.after_generate do |files|
        parsable_files = files.filter { |file| file.end_with?('.rb') }
        unless parsable_files.empty?
          system("bundle exec rubocop -A --fail-level=E #{parsable_files.shelljoin}", exception: true)
        end
      end
    end

    initializer 'practical-framework.view_helpers' do
      ActiveSupport.on_load(:action_view) do
        include PracticalFramework::Railtie::PracticalFrameworkFormBuilderActiveSupportExtension
        include PracticalFramework::ViewHelpers
        include PracticalFramework::ViewHelpers::IconHelpers
        include PracticalFramework::ViewHelpers::HoneybadgerHelpers
        include PracticalFramework::ViewHelpers::ThemeHelpers
      end
    end
  end
end
