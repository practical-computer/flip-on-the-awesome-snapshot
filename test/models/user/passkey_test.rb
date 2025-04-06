# frozen_string_literal: true

require "test_helper"

class User::PasskeyTest < ActiveSupport::TestCase
  include PracticalFramework::SharedTestModules::Models::Passkeys::BaseTests
  include PracticalFramework::SharedTestModules::Models::Passkeys::EmergencyRegistrationTests

  def model_class
    User::Passkey
  end

  def model_instance
    users.buffy.passkeys.first
  end

  def owner_reflection_name
    :user
  end

  def owner_instance
    users.buffy
  end

  def other_owner_instance
    users.rosa
  end

  def emergency_passkey_registration_reflection_name
    :emergency_passkey_registration
  end
end
