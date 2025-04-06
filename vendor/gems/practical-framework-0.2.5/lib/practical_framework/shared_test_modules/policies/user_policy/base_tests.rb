# frozen_string_literal: true

module PracticalFramework::SharedTestModules::Policies::UserPolicy::BaseTests
  extend ActiveSupport::Concern
  included do
    test "manage?: only true for the user" do
      user = users.organization_1_owner
      other_user = users.organization_2_owner

      assert_equal true, policy_class.new(user, user: user).apply(:manage?)
      assert_equal false, policy_class.new(user, user: other_user).apply(:manage?)
    end
  end
end