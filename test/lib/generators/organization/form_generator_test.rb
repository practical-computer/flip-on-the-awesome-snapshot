# frozen_string_literal: true

require "test_helper"
require "generators/organization/form/form_generator"

class Organization::FormGeneratorTest < Rails::Generators::TestCase
  tests Organization::FormGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator %w[Note tiptap_document resource]
  #   end
  # end
end
