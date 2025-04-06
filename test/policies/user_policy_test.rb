# frozen_string_literal: true

require "test_helper"

class UserPolicyTest < ActiveSupport::TestCase
  include PracticalFramework::SharedTestModules::Policies::UserPolicy::BaseTests

  def policy_class
    UserPolicy
  end
end