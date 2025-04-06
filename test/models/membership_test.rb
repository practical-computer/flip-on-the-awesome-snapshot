# frozen_string_literal: true

require "test_helper"

class MembershipTest < ActiveSupport::TestCase
  include PracticalFramework::SharedTestModules::Models::Memberships::BaseTests

  def model_class
    Membership
  end

  def user_reflection_name
    :user
  end

  def organization_reflection_name
    :organization
  end

  def organization_instance
    organizations.organization_1
  end

  def model_instance
    users.moonlighter.memberships.first
  end

  def other_user_instance
    users.organization_2_owner
  end
end
