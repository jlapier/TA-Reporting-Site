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
  
  attr_reader :csv, :pdf, :activities, :grouped_activities
  attr_accessor :export_format, :start_month, :end_month, :start_year, :end_year
  FILENAME_SUFFIX = "TA Activity Report"
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
      self.send("#{k.to_s}=".to_sym, v) if k.to_s =~ /(start_month|start_year|end_month|end_year)/
    end
  end
  
  def search=(search_obj)
    # TODO: get report to query the search obj for appropriate activities to report on
    @search = search_obj
    self.dates = {
      :start_year => @search.start_date.year,
      :start_month => @search.start_date.month,
      :end_year => @search.end_date.year,
      :end_month => @search.end_date.month
    }
  end
  
  # Force
  def start_month
    @start_month ||= 1
    @start_month.to_i
  end
  def start_year
    @start_year ||= Date.current.year
    @start_year.to_i
  end
  def end_month
    @end_month ||= Date.current.month - 1
    @end_month.to_i
  end
  def end_year
    @end_year ||= Date.current.year
    @end_year.to_i
  end
  def start_period=(date)
    self.start_year = date.year
    self.start_month = date.month
  end
  def end_period=(date)
    self.end_year = date.year
    self.end_month = date.month
  end
  def start_period
    return Date.new(start_year, start_month, 1)
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
  
  def activities
    @activities ||= Activity.all_between(start_period, end_period)
    #@activities ||= @search.activities
  end
  
  def grouped_activities
    @grouped_activities ||= {}
    if @grouped_activities == {}
      activities.group_by(&:objective).each do |objective, objective_activities|
        @grouped_activities[objective.number] = objective_activities
      end
    end
    @grouped_activities
  end
  
  def has_activities_like(options={})
    r = false
    if options[:objective]
      r = true unless grouped_activities[options.delete(:objective).number].nil?
    else
      r = activities.like(conditions).count > 0
    end
    return r
  end

  def to_csv
    @export_format = :csv
    export_to_format
  end
  
  def export_format
    @export_format ||= :csv
  end
  
  def export_to_format
    case export_format
    when :csv
      # TODO: figure out why FasterCSV is making the first line class,Activity
      @csv = FasterCSV.dump(activities).gsub("class,Activity\n", "") unless activities.empty?
    end
  end
end
