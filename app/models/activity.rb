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
  
  ACTIVITY_TYPES = [
    'Information request',
    'Teleconference/webinars',
    'Conference',
    'Consult - Phone/email/in-person',
    'Consult - onsite',
    'Workshop'
  ]
  
  LEVELS_OF_INTENSITY = [
    'General/Universal',
    'Targeted/Specific',
    'Intensive/Sustained'
  ]
  
  belongs_to :objective
  accepts_nested_attributes_for :objective
  
  has_and_belongs_to_many :states
  
  def self.activity_types
    ACTIVITY_TYPES
  end
  def self.levels_of_intensity
    LEVELS_OF_INTENSITY
  end
end
