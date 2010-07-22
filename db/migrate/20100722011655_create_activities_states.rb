class CreateActivitiesStates < ActiveRecord::Migration
  def self.up
    create_table :activities_states, :id => false do |t|
      t.integer :activity_id
      t.integer :state_id
    end
    add_index :activities_states, [:activity_id, :state_id]
  end

  def self.down
    drop_table :activities_states
  end
end
