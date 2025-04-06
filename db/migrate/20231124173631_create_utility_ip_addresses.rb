class CreateUtilityIPAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :utility_ip_addresses do |t|
      connection.adapter_name.downcase.to_sym
      if ActiveRecord::Base.connection.adapter_name.downcase.to_sym == :postgresql
        t.inet :address, null: false, index: {unique: true }
      else
        t.string :address, null: false, index: {unique: true }
      end

      t.timestamps
    end
  end
end
