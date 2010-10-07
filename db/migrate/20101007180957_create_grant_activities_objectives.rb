class CreateGrantActivitiesObjectives < ActiveRecord::Migration
  def self.up
    create_table :grant_activities_objectives, :id => false do |t|
      t.integer :grant_activity_id
      t.integer :objective_id
    end
    add_index :grant_activities_objectives, [:grant_activity_id, :objective_id]
  end

  def self.down
    drop_table :grant_activities_objectives
  end
end
