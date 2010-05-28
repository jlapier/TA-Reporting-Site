class CreateTaCategories < ActiveRecord::Migration
  def self.up
    create_table :ta_categories do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :ta_categories
  end
end
