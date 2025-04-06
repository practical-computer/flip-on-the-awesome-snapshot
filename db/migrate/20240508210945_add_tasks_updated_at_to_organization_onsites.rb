# frozen_string_literal: true

class AddTasksUpdatedAtToOrganizationOnsites < ActiveRecord::Migration[7.1]
  def change
    add_column :organization_onsites, :tasks_updated_at, :datetime
  end
end
