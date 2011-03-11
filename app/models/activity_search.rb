class ActivitySearch
  # these three lines make our regular ol' ruby class more railsy
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  def persisted?; false; end 

  attr_accessor :start_date, :end_date, :objective_id, :intensity_level_id,
                :ta_delivery_method_id,:grant_activity_id, :state_id,
                :ta_category_id, :collaborating_agency_id, :keywords
  
  def initialize(attributes_hash={})
    attributes_hash.each do |attr, val|
      self.send("#{attr}=", val) if self.respond_to?("#{attr}=")
    end
    normalize_dates
  end
  
  def normalize_dates
    if @start_date.blank?
      @start_date = Date.new(2010, 1, 1)
    elsif @start_date.kind_of?(String)
      @start_date = Date.parse(@start_date)
    end
    if @end_date.blank?
      @end_date = Date.current
    elsif @end_date.kind_of?(String)
      @end_date = Date.parse(@end_date)
    end
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
    @activities = Activity.where([str.join(" AND ")] + arr)
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
  
  def activities_scope
    @activities = @activities.all_between(@start_date, @end_date)
  end
  
  def activities
    activities_where
    activities_join
    activities_order
    activities_scope
  end
end
