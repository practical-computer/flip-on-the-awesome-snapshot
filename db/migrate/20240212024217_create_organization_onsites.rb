# frozen_string_literal: true

class CreateOrganizationOnsites < ActiveRecord::Migration[7.1]
  def change
    create_table :organization_onsites do |t|
      t.references :original_creator, null: false, foreign_key: { to_table: :users }
      t.references :job, null: false, foreign_key: { to_table: :organization_jobs }
      t.references :google_place, foreign_key: true
      t.string :label
      t.integer :priority, limit: 2, null: false
      t.integer :status, limit: 2, null: false

      t.timestamps
    end
  end
end
