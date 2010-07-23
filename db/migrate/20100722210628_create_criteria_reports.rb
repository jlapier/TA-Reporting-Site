class CreateCriteriaReports < ActiveRecord::Migration
  def self.up
    create_table :criteria_reports, :id => false do |t|
      t.integer :criteria_id
      t.integer :report_id
    end
    
    add_index :criteria_reports, [:criteria_id, :report_id]
  end

  def self.down
    drop_table :criteria_reports
  end
end
