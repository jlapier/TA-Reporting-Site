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
  
  belongs_to :objective
  belongs_to :activity_type
  belongs_to :intensity_level
  
  has_and_belongs_to_many :states
  has_and_belongs_to_many :ta_categories
  has_and_belongs_to_many :collaborating_agencies
  
  before_validation :remove_regions
  
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
