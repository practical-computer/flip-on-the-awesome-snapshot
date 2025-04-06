# frozen_string_literal: true

class Organization::FormGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  argument :attributes, type: :array, default: [], banner: "attribute attribute"

  def generate_form
    template "form.rb", "app/forms/organization/#{file_name}_form.rb"
  end

  def generate_test_stub
    template "test.rb", "test/forms/organization/#{file_name}_form_test.rb"
  end

  private

  def form_class_name
    "Organization::#{class_name}Form"
  end

  def policy_class_name
    "Organization::#{class_name}Policy"
  end
end
