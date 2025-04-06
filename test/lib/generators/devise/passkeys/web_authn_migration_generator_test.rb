# frozen_string_literal: true

require "test_helper"
require "generators/devise/passkeys/web_authn_migration/web_authn_migration_generator"

class Devise::Passkeys::WebAuthnMigrationGeneratorTest < Rails::Generators::TestCase
  tests Devise::Passkeys::WebAuthnMigrationGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
