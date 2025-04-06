# frozen_string_literal: true

require "test_helper"

class Administrator::PasskeyTest < ActiveSupport::TestCase
  include PracticalFramework::SharedTestModules::Models::Passkeys::BaseTests
  include PracticalFramework::SharedTestModules::Models::Passkeys::EmergencyRegistrationTests

  def model_class
    Administrator::Passkey
  end

  def model_instance
    administrators.kira.passkeys.first
  end

  def owner_reflection_name
    :administrator
  end

  def owner_instance
    administrators.kira
  end

  def other_owner_instance
    administrators.thomas
  end

  def emergency_passkey_registration_reflection_name
    :emergency_passkey_registration
  end
end
