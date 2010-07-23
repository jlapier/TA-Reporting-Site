class CreateCriteria < ActiveRecord::Migration
  def self.up
    create_table :criteria do |t|
      t.integer :number
      t.string :type
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :criteria
  end
end
