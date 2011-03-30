class SummaryReport
private
  def map_activity_ids(activities)    
    if activities.kind_of? ActiveRecord::Relation
      activity_ids = activities.select('activities.id').map(&:id)
    elsif activities.kind_of? Array and activities.first.kind_of? ActiveRecord::Base
      activity_ids = activities.map(&:id)
    elsif activities.kind_of? ActiveRecord::Base
      activity_ids = [activities.id]
    end
  end
protected
public
  attr_reader :ytd_date, :start_date, :end_date
  
  def initialize(start_date, end_date)
    @ytd_date = end_date.beginning_of_year
    @start_date = start_date
    @end_date = end_date
  end
  
  def ytd_activities
    @ytd_activities ||= Activity.all_between(@ytd_date, @end_date)
  end
  
  def period_activities
    @period_activities ||= Activity.all_between(@start_date, @end_date)
  end
  
  def ytd_state_count
    ytd_states.count
  end
  
  def ytd_states
    states_for(ytd_activities)
  end
  
  def period_state_count
    period_states.count
  end
  
  def period_states
    states_for(period_activities)
  end
  
  def states_for(activities, options={})
    options[:abbreviated] ||= true
    
    activity_ids = map_activity_ids(activities)
    
    activity_ids = [activity_ids] unless activity_ids.kind_of? Array  
    
    if options[:abbreviated]
      State.abbreviated_from(activity_ids)
    else
      State.from_activities(activity_ids)
    end
  end
  
  def state_stats_by_intensity_level_and_grant_activity
    conditions = {}
    stats = {}
    intensity_levels = IntensityLevel.all
    grant_activities = GrantActivity.all
    
    intensity_levels.each do |intensity_level|
      conditions.delete(:grant_activity)
      conditions.merge!({:intensity_level_id => intensity_level.id})
      stats[intensity_level.name] = {:activity_count => period_activities.like(conditions).count}
      
      next if ytd_activities.like(conditions).count == 0
      
      grant_activities.each do |grant_activity|
        
        conditions.merge!({:grant_activity => grant_activity})
        
        next if ytd_activities.like(conditions).count == 0

        states = states_for(period_activities.like(conditions))
        ytd_group_state_count = states_for(ytd_activities.like(conditions)).count

        next if ytd_group_state_count == 0
        
        states_sentence = states.map(&:abbreviation).to_sentence
        
        stats[intensity_level.name][grant_activity.name] = {
          :period_activity_count => period_activities.like(conditions).count,
          :period_state_sentence => states_sentence,
          :period_state_count => states.count,
          :ytd_state_count => ytd_group_state_count
        }
      end
    end
    
    # remove intensity_level keys pointing to empty values ie w/ no activities
    trim_empties(stats)
  end
  
  def trim_empties(stats)
    dirty_stats = stats.dup
    dirty_stats.each do |k,v|
      stats.delete(k) if v.empty?
    end
  end
end