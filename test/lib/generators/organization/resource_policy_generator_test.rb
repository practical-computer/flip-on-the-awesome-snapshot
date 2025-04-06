# frozen_string_literal: true

require "test_helper"
require "generators/organization/resource_policy/resource_policy_generator"

class Organization::ResourcePolicyGeneratorTest < Rails::Generators::TestCase
  tests Organization::ResourcePolicyGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["Note"]
  #   end
  # end
end
