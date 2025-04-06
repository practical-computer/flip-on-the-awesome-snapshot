# frozen_string_literal: true

class Organization::ResourcePolicyGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  def create_policy
    template "policy.rb", "app/policies/organization/#{file_name}_policy.rb"
  end

  def create_test
    template "test.rb", "test/policies/organization/#{file_name}_policy_test.rb"
  end

  private

  def policy_class_name
    "Organization::#{class_name}Policy"
  end
end
