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

class Objective < Criterium
  
  has_many :report_breakdowns
  
  def display_name
    "#{number}: #{name}"
  end
end
