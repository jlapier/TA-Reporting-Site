class RemoveStatesFromActivities < ActiveRecord::Migration
  def self.up
    remove_column :activities, :states
  end

  def self.down
    add_column :activities, :states, :string
  end
end
