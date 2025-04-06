class CreateMemberships < ActiveRecord::Migration[7.1]
  def change
    create_table :memberships do |t|
      t.integer :state, limit: 1, null: false
      t.datetime :accepted_at
      t.integer :membership_type, limit: 1, null: false
      t.references :organization, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
