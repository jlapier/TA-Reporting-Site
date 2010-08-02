class CreateReportBreakdowns < ActiveRecord::Migration
  def self.up
    create_table :report_breakdowns do |t|
      t.integer :report_id
      t.integer :objective_id
      t.string :breakdown_type
      t.boolean :include_states
    end
    
    add_index :report_breakdowns, [:report_id, :objective_id]
  end

  def self.down
    drop_table :report_breakdowns
  end
end
