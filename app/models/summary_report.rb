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
  
  attr_accessor :report_errors

  def report_title
    end_period.strftime(report_title_format || "%B %Y<br/>Monthly Report")
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
