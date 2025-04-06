# frozen_string_literal: true

require "test_helper"

class Organization::AttachmentsControllerTest < ActionDispatch::IntegrationTest
  include PracticalFramework::TestHelpers::ShrineTestData
  include PracticalFramework::SharedTestModules::Controllers::Organizations::AttachmentsController::BaseTests

  def assert_policies_applied(organization:, &block)
    assert_authorized_to(:show?, organization, with: OrganizationPolicy) do
      assert_authorized_to(:create?, nil, with: Organization::AttachmentPolicy, &block)
    end
  end
end