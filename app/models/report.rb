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
  
  include GeneralScopes
  
  attr_reader :csv, :activities, :grouped_activities
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
  
  def dates=(hash)
    hash.each do |k,v|
      self[k] = v if k =~ /(start_month|start_year|end_month|end_year)/
    end
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
    return Date.new(start_year || Date.current.months_ago(6).year, start_month || Date.current.months_ago(6).month, 01)
  end
  def end_period
    if range?
      date = Date.new(end_year, end_month)
      return Date.new(end_year, end_month, date.end_of_month.mday)
    else
      date = Date.new(start_year || Date.current.year, start_month || Date.current.month)
      return Date.new(start_year || Date.current.year, start_month || Date.current.month, date.end_of_month.mday)
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
  
  def load_grouped_activities
    load_activities unless @activities
    @grouped_activities = {}
    @activities.group_by(&:objective).each do |obj, actis|
      @grouped_activities[obj.number] ||= []
      @grouped_activities[obj.number] = actis
    end
  end
  
  def load_activities
    @activities = Activity.all_between(start_period, end_period)
  end

  def export
    export_to_format
  end
  
  def export_format
    @export_format || :csv
  end
  
  def export_to_format
    load_activities unless defined?(@activities)
    case export_format
    when :csv
      @csv = FasterCSV.dump(@activities) unless @activities.empty?
    end
  end
end
