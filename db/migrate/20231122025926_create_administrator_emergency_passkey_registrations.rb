class CreateAdministratorEmergencyPasskeyRegistrations < ActiveRecord::Migration[7.1]
  def change
    create_table :administrator_emergency_passkey_registrations do |t|
      t.references :administrator, null: false, foreign_key: true
      t.references :administrator_passkey, foreign_key: true
      t.references :utility_user_agent
      t.references :utility_ip_address
      t.timestamp :used_at

      t.timestamps
    end
  end
end
