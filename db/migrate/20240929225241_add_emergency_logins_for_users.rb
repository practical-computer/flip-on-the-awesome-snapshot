# frozen_string_literal: true

class AddEmergencyLoginsForUsers < ActiveRecord::Migration[7.1]
  def change
    change_table(:users) do |t|
      t.datetime :emergency_login_generated_at
    end
  end
end
