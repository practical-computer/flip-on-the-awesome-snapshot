class CreateOrganizationJobs < ActiveRecord::Migration[7.1]
  def change
    create_table :organization_jobs do |t|
      t.string :name
      t.references :organization, null: false, foreign_key: true
      t.references :original_creator, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
