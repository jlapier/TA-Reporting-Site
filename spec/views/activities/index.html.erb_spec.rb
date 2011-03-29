require 'spec_helper'

describe "/activities/index" do
  before(:each) do
    mock_objective = mock_model(Objective, {
        :name => "Obj 1", :display_name => "Obj 1", :number => 1, :id => 99 })
        
    activity = mock_model(Activity, {
      :id => 999,
      :description => 'Activity',
      :date_of_activity => 4.days.ago,
      :objective_id => mock_objective.id,
      :objective => mock_objective,
      :ta_delivery_method_id => nil,
      :ta_delivery_method => nil,
      :intensity_level_id => nil,
      :intensity_level => nil,
      :activity_grant_activities => [],
      :grant_activity_ids => [],
      :grant_activities => []
    })

    assign(:objectives, [mock_objective])
    assign(:ta_delivery_methods, [])
    assign(:intensity_levels, [])
    assign(:grant_activities, [])
    assign(:ta_categories, [])
    assign(:collaborating_agencies, [])
    assign(:states, [])

    assign(:search, ActivitySearch.new({
      :name => 'Search Name',
      :activities => []
    }))

    assign(:activities, [activity])
    render 
  end

  it "should load a list of activities" do
    rendered.should have_selector('h1', :content => "No Activity")
  end
end
