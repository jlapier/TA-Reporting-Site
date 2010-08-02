class AddIndexOnDateOfActivity < ActiveRecord::Migration
  def self.up
    add_index :activities, :date_of_activity
  end

  def self.down
    remove_index :activities, :date_of_activity
  end
end
