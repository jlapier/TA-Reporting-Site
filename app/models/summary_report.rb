# SummaryReport is used to load ytd and current activities from a given
# start_date and end_date. YTD is implied as Jan. 1st, end_date.year.
# Loading activities here vs. ActivitySearch requires slightly different
# behavior since we only care about start and end date filters
# when generating report summaries.
class SummaryReport
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
    states_for(ytd_activities.select('id').map(&:id))
  end
  
  def period_state_count
    period_states.count
  end
  
  def period_states
    states_for(period_activities.select('id').map(&:id))
  end
  
  def states_for(activity_ids)
    activity_ids = [activity_ids] unless activity_ids.kind_of? Array
    State.abbreviated_from(activity_ids)
  end
  
  def state_stats_by_intensity_level_and_grant_activity
    conditions = {}
    stats = {}
    intensity_levels = IntensityLevel.all
    grant_activities = GrantActivity.all
    
    intensity_levels.each do |intensity_level|
      
      conditions.merge!({:intensity_level_id => intensity_level.id})
      stats[intensity_level.name] = {}
      
      next if ytd_activities.like(conditions).count == 0
      
      grant_activities.each do |grant_activity|
        
        conditions.merge!({:grant_activity => grant_activity})
        
        next if ytd_activities.like(conditions).count == 0
        
        activity_ids = period_activities.like(conditions).
                                  select('activities.id').all.map(&:id)

        states = states_for(activity_ids)
        ytd_state_count = states_for(ytd_activities.like(conditions).
                                  select('activities.id').all.map(&:id)).count

        #next if ytd_state_count == 0
        states_sentence = if ytd_state_count == 0
            "Warning: None of these activities will be reported as having been for some state."
          else
            states.map(&:abbreviation).to_sentence
          end
        
        stats[intensity_level.name][grant_activity.name] = {
          :period_activity_count => period_activities.like(conditions).count,
          :period_state_sentence => states_sentence,
          :period_state_count => states.count,
          :ytd_state_count => ytd_state_count
        }
      end
    end
    
    # remove intensity_level keys pointing to empty values ie w/ no activities
    dirty_stats = stats.dup
    dirty_stats.each do |k,v|
      stats.delete(k) if v.empty?
    end
    
    stats
  end
end