# frozen_string_literal: true

module PracticalFramework::SharedTestModules::Models::EmergencyPasskeyRegistrations::BaseTests
  extend ActiveSupport::Concern

  included do
    test "belongs_to the owner of the registration" do
      reflection = model_class.reflect_on_association(owner_reflection_name)
      assert_equal :belongs_to, reflection.macro
    end

    test "requires an owner to be valid" do
      instance = model_instance
      instance.send(:"#{owner_reflection_name}=", nil)

      assert_equal false, instance.valid?
      assert_equal true, instance.errors.of_kind?(owner_reflection_name, :blank)

      instance.send(:"#{owner_reflection_name}=", owner_instance)
      instance.valid?

      assert_equal false, instance.errors.of_kind?(owner_reflection_name, :blank)
    end

    test "optionally belongs_to utility_user_agent" do
      reflection = model_class.reflect_on_association(:utility_user_agent)
      assert_equal :belongs_to, reflection.macro
      assert_equal "Utility::UserAgent", reflection.class_name
      assert_equal true, reflection.options[:optional]
    end

    test "optionally belongs_to utility_ip_address" do
      reflection = model_class.reflect_on_association(:utility_ip_address)
      assert_equal :belongs_to, reflection.macro
      assert_equal "Utility::IPAddress", reflection.class_name
      assert_equal true, reflection.options[:optional]
    end

    test "optionally belongs_to a passkey" do
      reflection = model_class.reflect_on_association(:passkey)
      assert_equal :belongs_to, reflection.macro
      assert_equal true, reflection.options[:optional]
    end

    test "available: scope only returns instances where used_at is nil" do
      instance = model_instance
      assert_nil instance.used_at

      assert_includes model_class.available, instance

      instance.update!(used_at: Time.now.utc)

      assert_not_includes model_class.available, instance
    end

    test "generates_token_for emergency_registration that expires within the designated time" do
      instance = model_instance

      token = instance.generate_token_for(:emergency_registration)

      assert_equal instance, model_class.find_by_token_for(:emergency_registration, token)

      Timecop.freeze(Time.now.utc + expiration_timespan) do
        assert_nil model_class.find_by_token_for(:emergency_registration, token)
      end
    end

    test "generates_token_for emergency_registration that expires when used_at is set" do
      instance = model_instance

      token = instance.generate_token_for(:emergency_registration)

      assert_equal instance, model_class.find_by_token_for(:emergency_registration, token)

      instance.update!(used_at: Time.now.utc)

      assert_nil model_class.find_by_token_for(:emergency_registration, token)
    end
  end
end