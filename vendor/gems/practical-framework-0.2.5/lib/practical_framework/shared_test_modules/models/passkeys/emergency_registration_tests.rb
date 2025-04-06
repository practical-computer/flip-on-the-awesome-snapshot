# frozen_string_literal: true

module PracticalFramework::SharedTestModules::Models::Passkeys::EmergencyRegistrationTests
  extend ActiveSupport::Concern

  included do
    test "optionally belongs_to an emergency_passkey_registration" do
      reflection = model_class.reflect_on_association(emergency_passkey_registration_reflection_name)
      assert_equal :belongs_to, reflection.macro
      assert_equal true, reflection.options[:optional]
    end
  end
end