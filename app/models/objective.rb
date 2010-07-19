# == Schema Information
#
# Table name: objectives
#
#  id         :integer       not null, primary key
#  number     :integer       
#  name       :string(255)   
#  created_at :datetime      
#  updated_at :datetime      
# End Schema

class Objective < ActiveRecord::Base
  has_many :activities
end
