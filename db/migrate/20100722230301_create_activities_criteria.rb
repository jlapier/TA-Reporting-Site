class CreateActivitiesCriteria < ActiveRecord::Migration
  def self.up
    create_table :activities_criteria, :id => false do |t|
      t.integer :activity_id
      t.integer :criterium_id
    end
    add_index :activities_criteria, [:activity_id, :criterium_id]
  end

  def self.down
    drop_table :activities_criteria
  end
end
