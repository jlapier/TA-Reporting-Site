class ActivitySearch
  # these three lines make our regular ol' ruby class more railsy
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  def persisted?; false; end 
  
  attr_reader :summary_report

  attr_accessor :start_date, :end_date, :objective_id, :intensity_level_id,
                :ta_delivery_method_id,:grant_activity_id, :state_id,
                :ta_category_id, :collaborating_agency_id, :keywords
  
  def initialize(attributes_hash={})
    attributes_hash.each do |attr, val|
      self.send("#{attr}=", val) if self.respond_to?("#{attr}=")
    end
    normalize_dates
    @summary_report = SummaryReport.new(@start_date, @end_date)
  end
  
  def ytd_period
    a = summary_report.ytd_date.strftime("%b %Y")
    b = @end_date.strftime("%b %Y")
    "#{a} - #{b}"
  end
  
  def period
    a = @start_date.strftime("%b %Y")
    b = @end_date.strftime("%b %Y")
    "#{a} - #{b}"
  end
  
  def name
    start = @start_date.strftime("%B %Y")
    finish = @end_date.strftime("%B %Y")
    count = activities.count
    prefix = if count == 0
      "No Activity"
    elsif count == 1
      "1 Activity"
    else
      "#{count} Activities"
    end
    "#{prefix} from #{start} to #{finish}"
  end
  
  def normalize_dates
    if @start_date.blank?
      @start_date = Date.current.beginning_of_month
    elsif @start_date.kind_of?(String)
      @start_date = Date.parse(@start_date)
    end
    if @end_date.blank?
      @end_date = Date.current
    elsif @end_date.kind_of?(String)
      @end_date = Date.parse(@end_date)
    end
  end
  
  def activities_includes
    @activities = Activity.includes(:states, :ta_categories)
  end
  
  def activities_where
    str = []
    arr = []
    unless @objective_id.blank?
      str << "objective_id = ?"
      arr << @objective_id
    end
    unless @intensity_level_id.blank?
      str << "intensity_level_id = ?"
      arr << @intensity_level_id
    end
    unless @ta_delivery_method_id.blank?
      str << "ta_delivery_method_id = ?"
      arr << @ta_delivery_method_id
    end
    unless @keywords.blank?
      str << "'activities'.description LIKE ?"
      arr << "%#{@keywords}%"
    end
    @activities = @activities.where([str.join(" AND ")] + arr)
  end
  
  def activities_join
    unless @grant_activity_id.blank?
      @activities = @activities.joins(:grant_activities).
                          where(["grant_activity_id = ?", @grant_activity_id])
    end
    unless @state_id.blank?
      @activities = @activities.joins(:states).
                                where(["state_id = ?", @state_id])
    end
    unless @ta_category_id.blank?
      @activities = @activities.joins(:ta_categories).
                                where(["ta_category_id = ?", @ta_category_id])
    end
    unless @collaborating_agency_id.blank?
      @activities = @activities.joins(:collaborating_agencies).
              where(["collaborating_agency_id = ?", @collaborating_agency_id])
    end
  end
  
  def activities_order
    @activities = @activities.order('date_of_activity DESC')
  end
  
  def activities_scope(ytd=false)
    sd = ytd ? summary_report.ytd_date : @start_date
    @activities = @activities.all_between(sd, @end_date)
  end
  
  def activities
    activities_includes
    activities_where
    activities_join
    activities_order
    activities_scope
  end
  
  def ytd_activities
    activities_includes
    activities_where
    activities_join
    activities_order
    activities_scope(true)
  end
end
