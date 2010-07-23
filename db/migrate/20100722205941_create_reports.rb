class CreateReports < ActiveRecord::Migration
  def self.up
    create_table :reports do |t|
      t.string :name
      t.boolean :include_descriptions
      t.date :begin_date
      t.date :end_date

      t.timestamps
    end
  end

  def self.down
    drop_table :reports
  end
end
