# frozen_string_literal: true

require "rails/generators/erb/scaffold/scaffold_generator"

class Erb::OrganizationScaffoldGenerator < Erb::Generators::ScaffoldGenerator
  source_root File.expand_path("templates", __dir__)

  def copy_view_files
    available_views.each do |view|
      formats.each do |format|
        filename = filename_with_extensions(view, format)
        template filename, File.join("app/views", controller_file_path, filename)
      end
    end

    template "table_partial.html.erb", File.join("app/views", controller_file_path, "_#{plural_name}_table.html.erb")
    template "table_row_partial.html.erb", File.join("app/views", controller_file_path, "_#{singular_name}_table_row.html.erb")
  end

  private
    def controller_file_path
      return super if super.start_with?("organizations/")
      return super.gsub(/^organization\//, "organizations/") if super.start_with?("organization/")
      return "organizations/#{super}"
    end

    def available_views
      %w(index _form new edit show)
    end
end
