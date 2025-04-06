# frozen_string_literal: true

class AddTimezoneToOrganization < ActiveRecord::Migration[7.1]
  def change
    change_table(:organizations) do |t|
      t.string :timezone, null: false, default: "UTC"
    end
  end
end
