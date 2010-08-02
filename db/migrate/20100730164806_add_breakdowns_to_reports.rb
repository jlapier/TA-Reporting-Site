class AddBreakdownsToReports < ActiveRecord::Migration
  def self.up
    add_column :reports, :primary_breakdown, :string
    add_column :reports, :secondary_breakdown, :string
  end

  def self.down
    remove_column :reports, :primary_breakdown
    remove_column :reports, :secondary_breakdown
  end
end
