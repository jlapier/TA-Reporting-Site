class RenameActivityStateListToStates < ActiveRecord::Migration
  def self.up
    rename_column :activities, :state_list, :states
  end

  def self.down
    rename_column :activities, :states, :state_list
  end
end
