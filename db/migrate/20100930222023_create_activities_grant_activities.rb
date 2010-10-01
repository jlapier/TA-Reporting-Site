class CreateActivitiesGrantActivities < ActiveRecord::Migration
  def self.up
    create_table :activities_grant_activities, :id => false do |t|
      t.integer :activity_id, :grant_activity_id
    end
  end

  def self.down
    drop_table :activities_grant_activities
  end
end
