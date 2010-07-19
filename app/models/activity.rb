# == Schema Information
#
# Table name: activities
#
#  id                 :integer       not null, primary key
#  date_of_activity   :date          
#  objective_id       :integer       
#  activity_type      :string(255)   
#  state_list         :string(255)   
#  description        :text          
#  level_of_intensity :string(255)   
#  created_at         :datetime      
#  updated_at         :datetime      
# End Schema

class Activity < ActiveRecord::Base
  belongs_to :objective
  accepts_nested_attributes_for :objective
end
