class MigrateActivityTypesToGrantActivities < ActiveRecord::Migration
  def self.up
    types = ActivityType.all
    types.each do |type|
      type.type = 'GrantActivity'
      type.save!
    end
    
    activities = Activity.find(:all, :conditions => "activity_type_id is not null")
    activities.each do |activity|
      grant_activity = GrantActivity.find(activity.activity_type_id)
      activity.grant_activities << grant_activity
      activity.save!
      activity.update_attribute(:activity_type_id, '')
    end
  end

  def self.down
    raise "No Rollback!"
  end
end
