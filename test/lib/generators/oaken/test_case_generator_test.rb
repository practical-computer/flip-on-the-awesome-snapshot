# frozen_string_literal: true

require "test_helper"
require "generators/oaken/test_case/test_case_generator"

class Oaken::TestCaseGeneratorTest < Rails::Generators::TestCase
  tests Oaken::TestCaseGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
