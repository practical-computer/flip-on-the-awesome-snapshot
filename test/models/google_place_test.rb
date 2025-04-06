# frozen_string_literal: true

require "test_helper"

class GooglePlaceTest < ActiveSupport::TestCase
  test "google_place_api_id: is required and cannot be blank" do
    instance = GooglePlace.new
    assert_equal false, instance.valid?
    assert_equal true, instance.errors.of_kind?(:google_place_api_id, :blank)

    instance.google_place_api_id = SecureRandom.hex

    assert_equal true, instance.valid?
    assert_equal false, instance.errors.of_kind?(:google_place_api_id, :blank)
  end

  test "google_place_api_id: is unique" do
    old_google_place_api_id = SecureRandom.hex

    GooglePlace.create!(google_place_api_id: old_google_place_api_id)

    instance = GooglePlace.new(google_place_api_id: old_google_place_api_id)

    assert_equal false, instance.valid?
    assert_equal true, instance.errors.of_kind?(:google_place_api_id, :taken)

    instance.google_place_api_id = SecureRandom.hex

    assert_equal true, instance.valid?
    assert_equal false, instance.errors.of_kind?(:google_place_api_id, :taken)
  end

  test "upsert_google_place: upserts a given google place" do
    google_place_api_id = SecureRandom.hex
    address = Faker::Address.full_address

    assert_difference "GooglePlace.count", +1 do
      instance = GooglePlace.upsert_google_place(google_place_api_id: google_place_api_id, human_address: address)
      assert_equal instance, GooglePlace.upsert_google_place(google_place_api_id: google_place_api_id, human_address: address)
    end
  end

  test "has_many :organization_jobs" do
    reflection = GooglePlace.reflect_on_association(:organization_jobs)
    assert_equal :has_many, reflection.macro
  end
end
