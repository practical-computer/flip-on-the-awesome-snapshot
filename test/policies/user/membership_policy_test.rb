# frozen_string_literal: true

require "test_helper"

class User::MembershipPolicyTest < ActiveSupport::TestCase
  include PracticalFramework::SharedTestModules::Policies::User::MembershipPolicy::BaseTests

  def policy_for(membership:, user:)
    User::MembershipPolicy.new(membership, user: user)
  end
end