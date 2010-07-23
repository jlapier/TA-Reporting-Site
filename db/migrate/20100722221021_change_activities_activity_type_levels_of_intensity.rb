class ChangeActivitiesActivityTypeLevelsOfIntensity < ActiveRecord::Migration
  def self.up
    rename_column :activities, :activity_type, :activity_type_id
    rename_column :activities, :level_of_intensity, :intensity_level_id
    change_column :activities, :activity_type_id, :integer
    change_column :activities, :intensity_level_id, :integer
  end

  def self.down
    rename_column :activities, :activity_type_id, :activity_type
    rename_column :activities, :intensity_level_id, :level_of_intensity
    change_column :activities, :activity_type, :string
    change_column :activities, :level_of_intensity, :string
  end
end
