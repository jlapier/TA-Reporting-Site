# == Schema Information
#
# Table name: report_breakdowns
#
#  id             :integer       not null, primary key
#  report_id      :integer       
#  objective_id   :integer       
#  breakdown_type :string(255)   
#  include_states :boolean       
# End Schema

class ReportBreakdown < ActiveRecord::Base
  belongs_to :report
  belongs_to :objective
  
  validates_presence_of :objective, :report
  validates_uniqueness_of :objective_id, :scope => :report_id
end
