# frozen_string_literal: true

module PracticalFramework::SharedTestModules::Policies::User::PasskeyPolicy::BaseTests
  extend ActiveSupport::Concern
  included do
    test "manage?: only true for the user's passkeys" do
      user = users.organization_1_department_head
      passkey = user.passkeys.create!(
        label: Faker::Device.manufacturer,
        external_id: SecureRandom.hex,
        public_key: SecureRandom.hex
      )
      other_user = users.organization_2_owner

      assert_equal true, policy_class.new(passkey, user: user).apply(:manage?)
      assert_equal false, policy_class.new(passkey, user: other_user).apply(:manage?)
    end
  end
end