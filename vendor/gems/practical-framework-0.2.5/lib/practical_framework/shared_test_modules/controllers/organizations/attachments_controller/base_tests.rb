# frozen_string_literal: true

module PracticalFramework::SharedTestModules::Controllers::Organizations::AttachmentsController::BaseTests
  extend ActiveSupport::Concern
  included do
    test "create: saves a new attachment" do
      user = users.moonlighter
      organization = organizations.organization_1
      sign_in(user)

      assert_policies_applied(organization: organization) do
      assert_difference "Organization::Attachment.count", +1 do
        post organization_attachments_url(organization), params: { file: fixture_file_upload('dog.jpeg') }
      end
      end

      new_attachment = organization.attachments.last

      assert_response :created
      assert_equal new_attachment.attachment.url, response.parsed_body[:url]
      assert_equal new_attachment, GlobalID::Locator.locate_signed(response.parsed_body[:sgid], for: :document)
    end
  end
end