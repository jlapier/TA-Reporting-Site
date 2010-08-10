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
  attr_accessor :activities
  
  belongs_to :report
  belongs_to :objective
  
  validates_presence_of :objective, :report
  validates_uniqueness_of :objective_id, :scope => :report_id

  def activities(start_period, end_period)
    @activities ||= {}
    if @activities == {}
      report.start_period = start_period
      report.end_period = end_period
      report.grouped_activities[objective.number].each do |activity|
        key = breakdown_type.blank? ? '' : activity.send(breakdown_type.underscore).send(:name)
        @activities[key] ||= []
        @activities[key] << activity
      end unless report.grouped_activities[objective.number].nil?
    end
    @activities
  end
  
  def has_activities_between(start_period, end_period)
    !activities(start_period, end_period).nil? &&
    !activities(start_period, end_period).empty?
  end
end
