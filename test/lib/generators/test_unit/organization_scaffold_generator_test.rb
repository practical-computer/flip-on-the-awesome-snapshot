# frozen_string_literal: true

require "test_helper"
require "generators/test_unit/organization_scaffold/organization_scaffold_generator"

class TestUnit::OrganizationScaffoldGeneratorTest < Rails::Generators::TestCase
  tests TestUnit::OrganizationScaffoldGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
