# frozen_string_literal: true

require "test_helper"
require "generators/devise/passkeys/install/install_generator"

class Devise::Passkeys::InstallGeneratorTest < Rails::Generators::TestCase
  tests Devise::Passkeys::InstallGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination
end
