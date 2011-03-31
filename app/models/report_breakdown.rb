# == Schema Information
#
# Table name: report_breakdowns
#
#  id                 :integer       not null, primary key
#  report_id          :integer       
#  objective_id       :integer       
#  breakdown_type     :string(255)   
#  include_states     :boolean       
#  include_in_summary :boolean       
# End Schema

class ReportBreakdown < ActiveRecord::Base
  
  HINTS = {
    :objective => "Each Report is made up of Sections. Each Section contains"+
                  " State &amp; Activities pertaining to a single"+
                  " Objective.",
    :breakdown_type => "Within each Section you can Group Activities by some"+
                       " Grant Activity, Level of Intensity, TA "+
                       "Category or TA Delivery Method.",
    :include_states => "Display list of States &amp; Regions"+
                       " with each Activity?",
    :include_in_summary => "Display Section's Activity statistics"+
                           " in the Summary Report?"
  }
  
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
        if breakdown_type.blank?
          @activities[''] ||= []
          @activities[''] << activity
        elsif activity.respond_to?(breakdown_type.underscore) and activity.send(breakdown_type.underscore)
          key = activity.send(breakdown_type.underscore).send(:name)
          @activities[key] ||= []
          @activities[key] << activity
        elsif activity.respond_to?(breakdown_type.underscore.pluralize) and !activity.send(breakdown_type.underscore.pluralize).empty?
          activity.send(breakdown_type.underscore.pluralize).map(&:name).each do |key|
            @activities[key] ||= []
            @activities[key] << activity
          end
        end
      end unless report.grouped_activities[objective.number].nil?
    end
    @activities
  end
  
  def has_activities_between(start_period, end_period)
    !activities(start_period, end_period).nil? &&
    !activities(start_period, end_period).empty?
  end
end
