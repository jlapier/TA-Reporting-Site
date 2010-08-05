# == Schema Information
#
# Table name: activities
#
#  id                 :integer       not null, primary key
#  date_of_activity   :date          
#  objective_id       :integer       
#  activity_type_id   :integer(255)  
#  description        :text          
#  intensity_level_id :integer(255)  
#  created_at         :datetime      
#  updated_at         :datetime      
# End Schema

class Activity < ActiveRecord::Base
  
  attr_reader :new_ta_category
  attr_accessor :other
  
  belongs_to :objective
  belongs_to :activity_type
  belongs_to :intensity_level
  
  has_and_belongs_to_many :states
  has_and_belongs_to_many :ta_categories
  has_and_belongs_to_many :collaborating_agencies
  
  accepts_nested_attributes_for :ta_categories
  
  validates_presence_of :date_of_activity, :objective_id, :activity_type_id, 
    :description, :intensity_level_id

  before_validation :remove_regions
  
  named_scope :all_between, lambda{ |start_date, end_date|
    {
      :conditions => {
        :date_of_activity => start_date..end_date
      }
    }
  }
  
  private
    def remove_regions
      excluded_ids = State.regions.options(:select => 'id').collect{|r| r.id}
      self.state_ids = state_ids - excluded_ids
    end
  protected
  public
    def new_ta_category=(ta_category_name)
      @new_ta_category ||= ta_category_name
      unless ta_category_name.blank?
        self.ta_categories << TaCategory.find_or_create_by_name(ta_category_name)
      end
    end
    
    def is_like?(options)
      options.all? {|k,v| self.send(k) == v }
    end

    def csv_headers
      [
        'Date',
        'Objective',
        'Type',
        'Intensity',
        'TA Categories',
        'Agencies',
        'States'
      ]
    end
    def csv_dump(headers)
      [
        date_of_activity,
        "#{objective.number}: #{objective.name}",
        activity_type.name,
        intensity_level.name,
        ta_categories.collect{|ta| ta.name}.join('; '),
        collaborating_agencies.collect{|a| a.name}.join('; '),
        states.collect{|s| "#{s.name} (#{s.abbreviation})"}.join('; ')
      ]
    end
end
