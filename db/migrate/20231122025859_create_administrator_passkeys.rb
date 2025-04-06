class CreateAdministratorPasskeys < ActiveRecord::Migration[7.1]
  def change
    create_table :administrator_passkeys do |t|
      t.references :administrator, null: false, foreign_key: true
      t.string :label, null: false
      t.string :external_id, null: false, index: {unique: true }
      t.string :public_key, null: false, index: {unique: true }
      t.integer :sign_count
      t.datetime :last_used_at

      t.timestamps
    end
  end
end
