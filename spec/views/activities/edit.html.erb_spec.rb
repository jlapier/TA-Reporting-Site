require 'spec_helper'

describe "/activities/edit" do
  before(:each) do
    mock_objective = mock_model(Objective, {
        :name => "Obj 1" })
    mock_grant_activity = mock_model(GrantActivity, {
        :name => "GA 1" })

    assign(:grant_activities, [mock_grant_activity])
    assign(:states, State.all)

    assign(:activity, mock_model(Activity, {
      :description => 'Activity',
      :date_of_activity => 4.days.ago,
      :objective_id => mock_objective.id,
      :ta_delivery_method_id => nil,
      :intensity_level_id => nil,
      :activity_grant_activities => [],
      :grant_activity_ids => [],
      :ta_category_ids => [],
      :collaborating_agency_ids => [],
      :other => nil,
      :new_ta_category => nil,
      :state_ids => [],
      :errors => mock('Errors', {:[] => {:description => ''}})
    }))
    render 
  end

  it "should load the proper form" do
    rendered.should have_selector('h1', :content => "Editing Activity")
  end
end
