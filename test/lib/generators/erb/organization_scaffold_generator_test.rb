# frozen_string_literal: true

require "test_helper"
require "generators/erb/organization_scaffold/organization_scaffold_generator"

class Erb::OrganizationScaffoldGeneratorTest < Rails::Generators::TestCase
  tests Erb::OrganizationScaffoldGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
