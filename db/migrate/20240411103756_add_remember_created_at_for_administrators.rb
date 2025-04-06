# frozen_string_literal: true

class AddRememberCreatedAtForAdministrators < ActiveRecord::Migration[7.1]
  def change
    change_table :administrators do |t|
      t.datetime :remember_created_at
    end
  end
end
