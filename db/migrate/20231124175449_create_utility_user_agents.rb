class CreateUtilityUserAgents < ActiveRecord::Migration[7.1]
  def change
    create_table :utility_user_agents do |t|
      t.string :user_agent, null: false, index: {unique: true }

      t.timestamps
    end
  end
end
