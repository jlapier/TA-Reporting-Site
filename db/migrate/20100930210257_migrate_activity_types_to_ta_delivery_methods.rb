class MigrateActivityTypesToTaDeliveryMethods < ActiveRecord::Migration
  def self.up
    add_column :activities, :ta_delivery_method_id, :integer
    add_index :activities, :ta_delivery_method_id
    
    movers = ['Information request',
    'Teleconference/webinar',
    'Conference',
    'Consult - Phone/email/in-person',
    'Consult - onsite',
    'Workshop']
    
    types = ActivityType.find(:all, :conditions => {:name => movers})
    
    types.each do |type|
      type.type = 'TaDeliveryMethod'
      type.save!
    end
    
    type_ids = types.map(&:id)
    
    activities = Activity.find(:all, :conditions => {:activity_type_id => type_ids})
    
    activities.each do |activity|
      activity.update_attribute(:ta_delivery_method_id, activity.activity_type_id)
      activity.update_attribute(:activity_type_id, '')
    end
  end

  def self.down
    begin
      ActivityType
    rescue NameError => e
      raise "Cannot completely revert migration. #{e.message}"
    end
    
    movers = ['Information request',
    'Teleconference/webinar',
    'Conference',
    'Consult - Phone/email/in-person',
    'Consult - onsite',
    'Workshop']
    
    types = TaDeliveryMethod.find(:all, :conditions => {:name => movers})
    
    types.each do |type|
      type.type = 'ActivityType'
      type.save!
    end

    type_ids = types.map(&:id)

    activities = Activity.find(:all, :conditions => {:ta_delivery_method_id => type_ids})

    activities.each do |activity|
      activity.update_attribute(:activity_type_id, activity.ta_delivery_method_id)
      activity.update_attribute(:ta_delivery_method_id, '')
    end
    
    remove_column :activities, :ta_delivery_method_id
  end
end
