# frozen_string_literal: true

class CreateGooglePlaces < ActiveRecord::Migration[7.1]
  def change
    create_table :google_places do |t|
      t.string :google_place_api_id, index: {unique: true}
      t.string :human_address

      t.timestamps
    end
  end
end
