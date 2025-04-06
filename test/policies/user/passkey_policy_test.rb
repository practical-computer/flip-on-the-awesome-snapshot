# frozen_string_literal: true

require "test_helper"

class User::PasskeyPolicyTest < ActiveSupport::TestCase
  include PracticalFramework::SharedTestModules::Policies::User::PasskeyPolicy::BaseTests

  def policy_class
    User::PasskeyPolicy
  end
end