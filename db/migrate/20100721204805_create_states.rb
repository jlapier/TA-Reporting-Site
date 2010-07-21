class CreateStates < ActiveRecord::Migration
  def self.up
    create_table :states do |t|
      t.integer :region_id
      t.string :name
      t.string :abbreviation, :limit => 10
    end
    
    add_index :states, :region_id
  end

  def self.down
    drop_table :states
  end
end
