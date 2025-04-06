# frozen_string_literal: true

class Organization::AttachmentUploader < Shrine
  Attacher.validate do
    validate_max_size PracticalFramework::ShrineExtensions.max_file_size
    validate_mime_type PracticalFramework::ShrineExtensions.mime_types
    validate_extension PracticalFramework::ShrineExtensions.extensions
  end
end