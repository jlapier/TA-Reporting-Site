# == Schema Information
#
# Table name: states
#
#  id           :integer       not null, primary key
#  region_id    :integer       
#  name         :string(255)   
#  abbreviation :string(10)    
# End Schema

class State < ActiveRecord::Base
  
  include GeneralScopes
  
  belongs_to :region, :class_name => 'State'
  has_many :states, :foreign_key => :region_id, :order => 'name'
  
  has_and_belongs_to_many :activities
  
  named_scope :regions, :conditions => {:region_id => nil}, :include => :states, :order => 'name'
  named_scope :just_states, :conditions => "region_id IS NOT NULL", :order => "name"

  def name_or_abbrev
    name.split(' ').size > 2 ? abbreviation : name
  end
      
end
