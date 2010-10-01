class RemoveActivitiesCriteria < ActiveRecord::Migration
  def self.up
    drop_table :activities_criteria
  end

  def self.down
    create_table :activities_criteria, :id => false do |t|
      t.integer :activity_id, :criterium_id
    end
  end
end
