# frozen_string_literal: true

require "test_helper"
require "generators/organization/controller_scaffold/controller_scaffold_generator"

class Organization::ControllerScaffoldGeneratorTest < Rails::Generators::TestCase
  tests Organization::ControllerScaffoldGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
