# frozen_string_literal: true

require "test_helper"

class OrganizationResourceTest < ActiveSupport::TestCase
  def self.policy_class
    OrganizationResourcePolicy
  end

  include PracticalFramework::SharedTestModules::Policies::OrganizationResourcePolicy::BaseTests
end