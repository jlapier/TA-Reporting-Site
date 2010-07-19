# == Schema Information
#
# Table name: ta_categories
#
#  id         :integer       not null, primary key
#  name       :string(255)   
#  created_at :datetime      
#  updated_at :datetime      
# End Schema

class TaCategory < ActiveRecord::Base
end
