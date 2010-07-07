# == Schema Information
#
# Table name: collaborating_agencies
#
#  id         :integer       not null, primary key
#  name       :string(255)   
#  abbrev     :string(255)   
#  created_at :datetime      
#  updated_at :datetime      
# End Schema

class CollaboratingAgency < ActiveRecord::Base
end
