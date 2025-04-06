class CreateAdministrators < ActiveRecord::Migration[7.1]
  def change
    create_table :administrators do |t|
      t.string :email
      t.string :webauthn_id
      t.integer :sign_in_count
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip

      t.timestamps
    end
    add_index :administrators, :webauthn_id, unique: true
    add_index :administrators, :email, unique: true
  end
end
