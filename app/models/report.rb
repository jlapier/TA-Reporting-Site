# == Schema Information
#
# Table name: reports
#
#  id                   :integer       not null, primary key
#  name                 :string(255)   
#  include_descriptions :boolean       
#  created_at           :datetime      
#  updated_at           :datetime      
#  primary_breakdown    :string(255)   
#  secondary_breakdown  :string(255)   
# End Schema

class Report < ActiveRecord::Base
  attr_reader :csv
  attr_accessor :export_format, :start_month, :end_month, :start_year, :end_year
  FILENAME_SUFFIX = "TA Activity Report.csv"
  YEAR_MONTH_DIGITS = "%Y-%m"
  MONTH_YEAR = "%Y %B"
  
  has_many :report_breakdowns
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  def period?
    !start_month.blank? && !start_year.blank? && end_month.blank? && end_year.blank?
  end
  
  def range?
    !start_month.blank? && !start_year.blank? && !end_month.blank? && !end_year.blank?
  end
  
  # Force
  def start_month
    @start_month.to_i unless @start_month.blank?
  end
  def start_year
    @start_year.to_i unless @start_year.blank?
  end
  def end_month
    @end_month.to_i unless @end_month.blank?
  end
  def end_year
    @end_year.to_i unless @end_year.blank?
  end
  
  def start_period
    return Date.new(start_year, start_month, 01) 
  end
  def end_period
    if range?
      date = Date.new(end_year, end_month)
      return Date.new(end_year, end_month, date.end_of_month.mday)
    else
      date = Date.new(start_year, start_month)
      return Date.new(start_year, start_month, date.end_of_month.mday)
    end
  end
  
  def export_filename
    out = ''
    if period?
      out = "#{start_period.strftime(YEAR_MONTH_DIGITS)} "
    elsif range?
      out = "#{start_period.strftime(MONTH_YEAR)} - #{end_period.strftime(MONTH_YEAR)} "
    end
    unless name.blank?
      out += "#{name} "
    end
    out += FILENAME_SUFFIX
  end

  def export
    activities = Activity.find(:all, :conditions => [
      "date_of_activity >= ? and date_of_activity <= ?",
      start_period.strftime("%Y-%m-%d"), end_period.strftime("%Y-%m-%d")
    ])
    export_to_format(activities)
  end
  
  def export_format
    @export_format || :csv
  end
  
  def export_to_format(activities)
    case export_format
    when :csv
      @csv = FasterCSV.dump(activities) unless activities.empty?
    end
  end
end
