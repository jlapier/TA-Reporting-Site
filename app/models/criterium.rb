# == Schema Information
#
# Table name: criteria
#
#  id         :integer       not null, primary key
#  number     :integer       
#  type       :string(255)   
#  name       :string(255)   
#  created_at :datetime      
#  updated_at :datetime      
# End Schema

class Criterium < ActiveRecord::Base
  
  TYPE_OPTIONS = [
    ['Activity Type','ActivityType'],
    ['Level of Intensity', 'IntensityLevel'],
    ['Objective', 'Objective'],
    ['TA Category', 'TACategory']
  ]
  
  has_many :activities
  has_and_belongs_to_many :reports
  
  def self.type_options
    TYPE_OPTIONS
  end
  
  def kind=(val)
    @kind = val
    self.type = val
  end
  def kind
    self.type
  end
end
