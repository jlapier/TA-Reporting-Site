class CreateSummaryReports < ActiveRecord::Migration
  def self.up
    create_table :summary_reports do |t|
      t.string :name
      t.date :start_ytd
      t.date :start_period
      t.date :end_period
      t.string :report_title_format

      t.timestamps
    end
  end

  def self.down
    drop_table :summary_reports
  end
end
