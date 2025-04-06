# frozen_string_literal: true

class AddStatusEnumToOrganizationJob < ActiveRecord::Migration[7.1]
  def change
    add_column :organization_jobs, :status, :integer, limit: 2, null: false
  end
end
