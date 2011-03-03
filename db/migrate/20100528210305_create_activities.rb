class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.date :date_of_activity
      t.integer :objective_id
      t.string :activity_type
      t.string :state_list
      t.text :description
      t.string :level_of_intensity

      t.timestamps
    end
    add_index :activities, :objective_id
    add_index :activities, :activity_type
    add_index :activities, :level_of_intensity

    create_table "activities_ta_categories", :id => false, :force => true do |t|
      t.integer "activity_id"
      t.integer "ta_category_id"
    end

    create_table "activities_collaborating_agencies", :id => false, :force => true do |t|
      t.integer "activity_id"
      t.integer "collaborating_agency_id"
    end

    add_index "activities_ta_categories", ["activity_id"]
    add_index "activities_ta_categories", ["ta_category_id"]

    add_index "activities_collaborating_agencies", ["activity_id"]
    add_index "activities_collaborating_agencies", ["collaborating_agency_id"], :name => "activities_collab_agencies_index"

  end

  def self.down
    drop_table :activities
  end
end
