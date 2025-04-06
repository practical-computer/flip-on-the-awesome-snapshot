class CreateUserEmergencyPasskeyRegistrations < ActiveRecord::Migration[7.1]
  def change
    create_table :user_emergency_passkey_registrations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :user_passkey, foreign_key: true
      t.references :utility_user_agent
      t.references :utility_ip_address
      t.datetime :used_at

      t.timestamps
    end
  end
end
