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

class ActivityType < Criterium
  
  scope :find_by_lowercase_name, lambda { |name| 
    {
      :conditions => ["LOWER(name) = LOWER(?)", name]
    }
  }
    
end
