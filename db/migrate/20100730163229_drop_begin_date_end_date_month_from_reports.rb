class DropBeginDateEndDateMonthFromReports < ActiveRecord::Migration
  def self.up
    change_table :reports do |t|
      t.remove :begin_date, :end_date, :month
    end
  end

  def self.down
    change_table :reports do |t|
      t.date :begin_date
      t.date :end_date
      t.date :month
    end
  end
end
