class State < ActiveRecord::Base
  
  include GeneralScopes
  
  belongs_to :region, :class_name => 'State'
  has_many :states, :foreign_key => :region_id, :order => 'name'
  
  has_and_belongs_to_many :activities
  
  named_scope :regions, :conditions => {:region_id => nil}, :include => :states, :order => 'name'
end