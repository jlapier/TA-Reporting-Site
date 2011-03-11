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

class Criterium < ActiveRecord::Base
  
  TYPE_OPTIONS = [
    ['TA Delivery Method','TaDeliveryMethod'],
    ['Level of Intensity', 'IntensityLevel'],
    ['Objective', 'Objective'],
    ['TA Category', 'TaCategory'],
    ['Grant Activity', 'GrantActivity']
  ].sort
  
  has_many :activities
  
  validates_presence_of :name
  
  class << self
    def get(criterium_id)
      criteria = Rails.cache.read("all_criteria")
      unless criteria
        criteria = Criterium.find :all
        Rails.cache.write("all_criteria", criteria)
      end
      criteria.detect { |crit| crit.id == criterium_id }
    end
  end

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
