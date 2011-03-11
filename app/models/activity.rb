# == Schema Information
#
# Table name: activities
#
#  id                    :integer       not null, primary key
#  date_of_activity      :date          
#  objective_id          :integer       
#  activity_type_id      :integer(255)  
#  description           :text          
#  intensity_level_id    :integer(255)  
#  created_at            :datetime      
#  updated_at            :datetime      
#  ta_delivery_method_id :integer       
# End Schema

class Activity < ActiveRecord::Base

  include GeneralScopes
  
  DEFAULT_IMPORT_INTENSITY = 'Unknown'
  DEFAULT_IMPORT_TYPE = 'Information Request'
  DEFAULT_IMPORT_OBJECTIVE = 'Provide TA'
  
  attr_reader :new_ta_category
  attr_accessor :other
  
  belongs_to :objective
  belongs_to :ta_delivery_method
  belongs_to :intensity_level
  
  has_and_belongs_to_many :states
  has_and_belongs_to_many :ta_categories
  has_and_belongs_to_many :collaborating_agencies
  has_and_belongs_to_many :grant_activities
  
  accepts_nested_attributes_for :ta_categories
  
  validates_presence_of :date_of_activity, :objective_id,
    :description #, :intensity_level_id

  before_validation :remove_regions
  
  scope :all_between, lambda{ |start_date, end_date|
    {
      :conditions => { :date_of_activity => start_date..end_date },
      :include => [:grant_activities, :states, :ta_categories]
    }
  }
  
  private
    def remove_regions
      excluded_ids = State.regions.options(:select => 'id').collect{|r| r.id}
      self.state_ids = state_ids - excluded_ids
    end
  protected
  public
    def csv_headers
      [
        'Date',
        'Objective',
        'TA Delivery Method',
        'Grant Activities',
        'Intensity',
        'TA Categories',
        'Description of Activity',
        'Agencies',
        'States'
      ]
    end
    def csv_dump(headers)
      [
        date_of_activity,
        "#{objective.number}: #{objective.name}",
        ta_delivery_method ? ta_delivery_method.name : '',
        grant_activities.collect{|ga| ga.name}.join('; '),
        intensity_level ? intensity_level.name : 'unknown',
        ta_categories.collect{|ta| ta.name}.join('; '),
        description,
        collaborating_agencies.collect{|a| a.name}.join('; '),
        states.collect{|s| "#{s.name} (#{s.abbreviation})"}.join('; ')
      ]
    end
  
    def new_ta_category=(ta_category_name)
      @new_ta_category ||= ta_category_name
      unless ta_category_name.blank?
        self.ta_categories << TaCategory.find_or_create_by_name(ta_category_name)
      end
    end
    
    def is_like?(opts)
      options = opts.dup
      ga = options.delete(:grant_activity)
      ta_c = options.delete(:ta_category)
      options.all? {|k,v| self.send(k) == v } and 
        (ga.nil? or self.grant_activities.include?(ga)) and
        (ta_c.nil? or self.ta_categories.include?(ta_c))
    end
end
