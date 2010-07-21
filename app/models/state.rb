class State < ActiveRecord::Base
  belongs_to :region, :class_name => 'State'
  has_many :states, :foreign_key => :region_id
  
  #has_and_belongs_to_many :activities
  
  named_scope :regions, :conditions => {:region_id => nil}, :include => :states, :order => 'name'
end