class AddObjectiveIdToSummaryReport < ActiveRecord::Migration
  def self.up
    add_column :summary_reports, :objective_id, :integer
    add_index :summary_reports, :objective_id
  end

  def self.down
    remove_column :summary_reports, :objective_id
  end
end
