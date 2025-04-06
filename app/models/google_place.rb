# frozen_string_literal: true

class GooglePlace < ApplicationRecord
  validates :google_place_api_id, presence: true, allow_blank: false, uniqueness: true

  has_many :organization_jobs, class_name: "Organization::Job"

  def self.upsert_google_place(google_place_api_id:, human_address:)
    upsert({google_place_api_id: google_place_api_id, human_address: human_address},
           returning: [:id],
           unique_by: :google_place_api_id
          )
    find_by(google_place_api_id: google_place_api_id)
  end
end
