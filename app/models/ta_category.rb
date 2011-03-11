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

class TaCategory < Criterium
  has_and_belongs_to_many :activities
end
