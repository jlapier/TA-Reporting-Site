# == Schema Information
#
# Table name: reports
#
#  id                   :integer       not null, primary key
#  name                 :string(255)   
#  include_descriptions :boolean       
#  begin_date           :date          
#  end_date             :date          
#  created_at           :datetime      
#  updated_at           :datetime      
# End Schema

class Report < ActiveRecord::Base
  has_and_belongs_to_many :objectives
end
