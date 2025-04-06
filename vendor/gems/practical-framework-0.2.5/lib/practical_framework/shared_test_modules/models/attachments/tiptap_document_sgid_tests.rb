# frozen_string_literal: true

module PracticalFramework::SharedTestModules::Models::Attachments::TiptapDocumentSgidTests
  extend ActiveSupport::Concern
  included do
    test "sgid_for_document: creates a stable, signed, never expiring SGID with the :document purpose" do
      file = csv_file
      create_saved_attachment(file: file) do |attachment|
        sgid = attachment.sgid_for_document

        assert_equal sgid, attachment.sgid_for_document

        assert_equal attachment, GlobalID::Locator.locate_signed(sgid.to_s, for: :document)

        time = 100.years.from_now

        Timecop.freeze(time) do
          assert_equal attachment, GlobalID::Locator.locate_signed(sgid.to_s, for: :document)
        end
      end
    end
  end
end