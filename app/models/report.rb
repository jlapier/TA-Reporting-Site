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
  attr_accessor :period, :start_period, :end_period
  
  FILENAME_SUFFIX = "TA Activity Report.csv"
  YEAR_MONTH_DIGITS = "%Y-%m"
  SHORT_MONTH_DAY_YEAR = "%B %Y"
  
  has_many :report_breakdowns
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  def export_filename
    out = ''
    unless period.nil?
      out = "#{period.strftime(YEAR_MONTH_DIGITS)} "
    end
    unless start_period.nil? || end_period.nil?
      out = "#{start_period.strftime(SHORT_MONTH_DAY_YEAR)} - #{end_period.strftime(SHORT_MONTH_DAY_YEAR)} "
    end
    out += "#{name} #{FILENAME_SUFFIX}"
  end
  
  def csv_export
    # TODO: change this to a proper SQL search with dates; add an index to the activities table for date_of_activity
    activities = Activity.find(:all, :conditions => [
      "date_of_activity LIKE ?",
      "%#{self.period.to_s[0..3]}-#{self.period.to_s[5..6]}%"
    ])
    @csv = FasterCSV.dump(activities) unless activities.empty?
  end
end
