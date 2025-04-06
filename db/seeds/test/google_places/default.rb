# frozen_string_literal: true

google_places.create(:resident_1, google_place_api_id: Faker::Internet.uuid, human_address: Faker::Address.full_address)
google_places.create(:resident_2, google_place_api_id: Faker::Internet.uuid, human_address: Faker::Address.full_address)
google_places.create(:business, google_place_api_id: Faker::Internet.uuid, human_address: Faker::Address.full_address)