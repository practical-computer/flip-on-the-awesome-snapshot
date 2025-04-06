# frozen_string_literal: true

require "shrine"
require "shrine/storage/file_system"

if AppSettings.use_s3_storage?
  require "shrine/storage/s3"

  cache_s3 = Shrine::Storage::S3.new(prefix: "cache", **AppSettings.shrine_s3_options)
  store_s3 = Shrine::Storage::S3.new(prefix: "uploads", **AppSettings.shrine_s3_options)

  Shrine.storages = {
    cache: cache_s3, # temporary
    store: store_s3, # permanent
  }
else
  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"), # temporary
    store: Shrine::Storage::FileSystem.new("public", prefix: "uploads"),       # permanent
  }
end

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data # for retaining the cached file across form redisplays
Shrine.plugin :restore_cached_data # re-extract metadata when attaching a cached file
Shrine.plugin :validation
Shrine.plugin :validation_helpers
Shrine.plugin :determine_mime_type, analyzer: :marcel, analyzer_options: { filename_fallback: true }