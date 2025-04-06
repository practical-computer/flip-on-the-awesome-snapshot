# frozen_string_literal: true

class AddUniqueIndexToMemberships < ActiveRecord::Migration[7.1]
  def change
    change_table(:memberships) do |t|
      t.index [:user_id, :organization_id], unique: true
    end
  end
end
