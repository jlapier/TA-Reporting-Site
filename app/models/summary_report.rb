# == Schema Information
#
# Table name: summary_reports
#
#  id                  :integer       not null, primary key
#  name                :string(255)   
#  start_ytd           :date          
#  start_period        :date          
#  end_period          :date          
#  report_title_format :string(255)   
#  created_at          :datetime      
#  updated_at          :datetime      
# End Schema

class SummaryReport < ActiveRecord::Base
  validates_presence_of :name
  
  attr_accessor :report_errors, :start_ytd_month, :start_month, :end_month, :start_ytd_year, :start_year, :end_year

  def dates=(hash)
    hash.each do |k,v|
      self.send("#{k.to_s}=".to_sym, v) if k.to_s =~ /(start_ytd_month|start_ytd_year|start_month|start_year|end_month|end_year)/
    end
    self.start_ytd    = Date.new(start_ytd_year.to_i,  start_ytd_month.to_i)  if start_ytd_year and start_ytd_month
    self.start_period = Date.new(start_year.to_i,      start_month.to_i)      if start_year and start_month
    self.end_period   = Date.new(end_year.to_i,        end_month.to_i)        if end_year and end_month
  end

  def report_title
    if ytd_activities
      end_period.strftime( report_title_format.blank? ? "%B %Y<br/>Monthly Report" : report_title_format)
    end
  end

  def ytd_activities
    if start_ytd and start_period and end_period
      @ytd_activities ||= Activity.all_between start_ytd, end_period
    else
      add_error "Unable to create report - not all dates are specified."
      nil
    end
  end

  def period_activities
    if ytd_activities
      @period_activities ||= ytd_activities.select { |activity| (start_period..end_period).include? activity.date_of_activity }
    else
      nil
    end
  end

  def activities_by_type_for_ytd(options)
    if ytd_activities
      ytd_activities.select { |activity| activity.is_like? options }
    else
      nil
    end
  end
  
  def activities_by_type_for_period(options)
    if period_activities
      period_activities.select { |activity| activity.is_like? options }
    else
      nil
    end
  end

  def states_by_type_for_ytd(options)
    acts = activities_by_type_for_ytd(options)
    if acts
      acts.map(&:states).flatten.uniq.sort_by(&:abbreviation)
    end
  end

  def states_by_type_for_period(options)
    acts = activities_by_type_for_period(options)
    if acts
      acts.map(&:states).flatten.uniq.sort_by(&:abbreviation)
    end
  end
  

  private
    def add_error(err_message)
      @report_errors ||= []
      @report_errors << err_message
    end
end
