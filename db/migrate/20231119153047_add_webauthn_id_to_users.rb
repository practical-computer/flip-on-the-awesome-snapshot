# frozen_string_literal: true

class AddWebauthnIdToUsers < ActiveRecord::Migration[7.1]
  def change
    change_table(:users) do |t|
      t.string :webauthn_id, null: false
      t.index :webauthn_id, unique: true
    end
  end
end
