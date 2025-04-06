# frozen_string_literal: true

class CreateOrganizationJobTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :organization_job_tasks do |t|
      t.integer :task_type, limit: 2
      t.integer :status, limit: 2
      t.integer :estimated_minutes
      t.string :label, null: false

      t.references :job, null: false, foreign_key: {to_table: :organization_jobs}
      t.references :onsite, foreign_key: {to_table: :organization_onsites}
      t.references :original_creator, null: false, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
