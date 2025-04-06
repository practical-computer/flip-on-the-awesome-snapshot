# frozen_string_literal: true

require "test_helper"
require "generators/oaken/model/model_generator"

class Oaken::ModelGeneratorTest < Rails::Generators::TestCase
  tests Oaken::ModelGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
