# frozen_string_literal: true

class AddThemeToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :theme, :integer, limit: 2, default: 0
  end
end
