class AddIncludeInSummaryToReportBreakdowns < ActiveRecord::Migration
  def self.up
    add_column :report_breakdowns, :include_in_summary, :boolean
  end

  def self.down
    remove_column :report_breakdowns, :include_in_summary
  end
end
