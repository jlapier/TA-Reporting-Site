class DropCriteriaReports < ActiveRecord::Migration
  def self.up
    drop_table :criteria_reports
  end

  def self.down
    create_table :criteria_reports, :id => false do |t|
      t.integer :criterium_id
      t.integer :report_id
    end
    add_index :criteria_reports, [:criterium_id, :report_id]
  end
end
