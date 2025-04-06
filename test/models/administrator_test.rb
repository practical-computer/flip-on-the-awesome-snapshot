# frozen_string_literal: true

require "test_helper"

class AdministratorPasskeyTests < ActiveSupport::TestCase
  include PracticalFramework::SharedTestModules::Models::ResourceUsingDevisePasskeys::BaseTests
  include PracticalFramework::SharedTestModules::Models::ResourceUsingDevisePasskeys::BaseEmergencyPasskeyRegistrationTests
  include PracticalFramework::SharedTestModules::Models::NormalizedEmailTests

  def passkey_class
    Administrator::Passkey
  end

  def emergency_passkey_registration_class
    Administrator::EmergencyPasskeyRegistration
  end

  def model_class
    Administrator
  end

  def passkey_instance
    administrators.kira.passkeys.first
  end

  def model_instance
    administrators.kira
  end
end
