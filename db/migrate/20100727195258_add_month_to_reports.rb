class AddMonthToReports < ActiveRecord::Migration
  def self.up
    add_column :reports, :month, :date
  end

  def self.down
    remove_column :reports, :month
  end
end
