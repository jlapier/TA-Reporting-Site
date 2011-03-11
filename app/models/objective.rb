# == Schema Information
#
# Table name: criteria
#
#  id          :integer       not null, primary key
#  number      :integer       
#  type        :string(255)   
#  name        :string(255)   
#  created_at  :datetime      
#  updated_at  :datetime      
#  description :text          
# End Schema

class Objective < Criterium
  
  include GeneralScopes
  
  has_many :report_breakdowns
  has_and_belongs_to_many :grant_activities
  
  def display_name
    "#{number}: #{name}"
  end
end
