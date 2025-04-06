# frozen_string_literal: true

require "test_helper"

class OrganizationPolicyTest < ActiveSupport::TestCase
  include PracticalFramework::SharedTestModules::Policies::OrganizationPolicy::BaseTests

  def policy(organization:, user:)
    OrganizationPolicy.new(organization, user: user)
  end

  def relation_policy(user:)
    OrganizationPolicy.new(user: user).apply_scope(Organization.all, type: :active_record_relation)
  end

  def policy_class
    OrganizationPolicy
  end
end