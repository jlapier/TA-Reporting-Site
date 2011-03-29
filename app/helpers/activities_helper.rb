module ActivitiesHelper
  def abbreviated_states_from(activities)
    # nicer this is to read but ups time spent in Views to ~ 12000 ms
    #  activities.map(&:states).flatten.map(&:abbreviation).uniq.sort.to_sentence
    
    # this spends ~ 2000 ms in Views; everything else being the same
    activity_ids = activities.map(&:id)
    activity_ids = [activity_ids] unless activity_ids.kind_of? Array
    states = State.abbreviated_from(activity_ids)
    {
      :count => states.count,
      :sentence => states.map(&:abbreviation).to_sentence
    }
  end
end