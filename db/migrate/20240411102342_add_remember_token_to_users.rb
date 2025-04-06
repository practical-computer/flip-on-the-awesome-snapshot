# frozen_string_literal: true

class AddRememberTokenToUsers < ActiveRecord::Migration[7.1]
  enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

  def change
    change_table :users do |t|
      t.text :remember_token, default: -> {"GEN_SALT('bf')"}, index: {unique: true}
    end
  end
end
