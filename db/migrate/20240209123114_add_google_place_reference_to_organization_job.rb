# frozen_string_literal: true

class AddGooglePlaceReferenceToOrganizationJob < ActiveRecord::Migration[7.1]
  def change
    add_reference :organization_jobs, :google_place, null: true, foreign_key: true
  end
end
