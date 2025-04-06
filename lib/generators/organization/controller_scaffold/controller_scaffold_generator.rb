# frozen_string_literal: true

require "rails/generators/rails/scaffold_controller/scaffold_controller_generator"

class Organization::ControllerScaffoldGenerator < Rails::Generators::ScaffoldControllerGenerator
  source_root File.expand_path("templates", __dir__)

  hook_for :template_engine, as: :organization_scaffold do |template_engine|
    invoke template_engine, [name] unless options.api?
  end

  hook_for :test_framework, as: :organization_scaffold

  remove_hook_for :resource_route

  if respond_to?(:jbuilder_generator)
    remove_hook_for :jbuilder
  end

  def add_localization_file
    invoke "organization:resource_localization"
  end

  private

  def name
    if super.start_with?("Organization::")
      return super
    else
      return "Organization::#{super}"
    end
  end

  def controller_class_path
    return super if super.first == "organizations"
    result = super

    if super.first == "organization"
      result.shift
    end

    result.prepend("organizations")

    return result
  end

  def controller_name
    return super if super.start_with?("Organizations::")
    return super.gsub(/^Organization::/, "Organizations::") if super.start_with?("Organization::")
    return "Organizations::#{super}"
  end

  def form_class_name
    "#{name}Form"
  end

  def policy_class_name
    "#{name}Policy"
  end
end
