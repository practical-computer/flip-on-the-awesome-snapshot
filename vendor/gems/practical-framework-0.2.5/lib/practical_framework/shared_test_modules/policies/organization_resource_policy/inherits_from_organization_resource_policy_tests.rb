# frozen_string_literal: true

module PracticalFramework::SharedTestModules::Policies::OrganizationResourcePolicy::InheritsFromOrganizationResourcePolicyTests
  extend ActiveSupport::Concern
  included do
    test "is a subclass of the resource_policy_class" do
      assert_includes policy_class.ancestors, resource_policy_class
    end
  end
end