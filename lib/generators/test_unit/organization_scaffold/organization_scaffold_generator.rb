# frozen_string_literal: true

require "rails/generators/test_unit/scaffold/scaffold_generator"

class TestUnit::OrganizationScaffoldGenerator < Rails::Generators::NamedBase
  include Rails::Generators::ResourceHelpers
  source_root File.expand_path("templates", __dir__)

  def generate_integration_test
    template "integration_test.rb", File.join("test/controllers/", "#{controller_file_path}_controller_test.rb")
    template "system_test.rb", File.join("test/system/", "#{controller_file_path}_test.rb")
  end

  private
    def controller_file_path
      return super if super.start_with?("organizations/")
      return super.gsub(/^organization\//, "organizations/") if super.start_with?("organization/")
      return "organizations/#{super}"
    end

    def controller_name
      return super if super.start_with?("Organizations::")
      return super.gsub(/^Organization::/, "Organizations::") if super.start_with?("Organization::")
      return "Organizations::#{super}"
    end

    def class_name
      return super if super.start_with?("Organization::")
      return super.gsub(/^Organizations::/, "Organization::") if super.start_with?("Organizations::")
      return "Organization::#{super}"
    end

    def policy_class_name
      "#{class_name}Policy"
    end
end
