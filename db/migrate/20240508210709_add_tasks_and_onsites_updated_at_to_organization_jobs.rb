# frozen_string_literal: true

class AddTasksAndOnsitesUpdatedAtToOrganizationJobs < ActiveRecord::Migration[7.1]
  def change
    add_column :organization_jobs, :tasks_and_onsites_updated_at, :datetime
  end
end
