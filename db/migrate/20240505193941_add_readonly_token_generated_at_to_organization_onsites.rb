# frozen_string_literal: true

class AddReadonlyTokenGeneratedAtToOrganizationOnsites < ActiveRecord::Migration[7.1]
  def change
    change_table(:organization_onsites) do |t|
      t.datetime :readonly_token_generated_at, null: false, default: -> {"CURRENT_TIMESTAMP"}
    end
  end
end
