# frozen_string_literal: true

require "test_helper"

class UserPasskeyTest < ActiveSupport::TestCase
  include PracticalFramework::SharedTestModules::Models::ResourceUsingDevisePasskeys::BaseTests
  include PracticalFramework::SharedTestModules::Models::ResourceUsingDevisePasskeys::BaseEmergencyPasskeyRegistrationTests
  include PracticalFramework::SharedTestModules::Models::Users::BaseTests

  def passkey_class
    User::Passkey
  end

  def emergency_passkey_registration_class
    User::EmergencyPasskeyRegistration
  end

  def model_class
    User
  end

  def passkey_instance
    users.buffy.passkeys.first
  end

  def model_instance
    users.buffy
  end

  test "has_many: attachments, through :organizations" do
    reflection =  User.reflect_on_association(:attachments)
    assert_equal :has_many, reflection.macro
    assert_equal :organizations, reflection.options[:through]
  end
end
