class ActivitySearch
  # these three lines make our regular ol' ruby class more railsy
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  def persisted?; false; end 

  attr_accessor :start_date, :end_date, :objective_id, :intensity_level_id, :ta_delivery_method_id, :keywords
  
  def initialize(attributes_hash)
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
  
  def activities
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
      str << "description LIKE ?"
      arr << "%#{@keywords}%"
    end
    search_options = [str.join(" AND ")] + arr
    @activities = Activity.all_between(@start_date, @end_date).options(:conditions => search_options, :order => 'date_of_activity DESC')
  end
end
