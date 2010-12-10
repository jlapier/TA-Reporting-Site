require 'spec_helper'

describe "/activities/edit" do
  before(:each) do
    mock_objective = mock_model(Objective, {
        :name => "Obj 1" })
    mock_grant_activity = mock_model(GrantActivity, {
        :name => "GA 1" })

    assigns[:grant_activities] = [mock_grant_activity]
    assigns[:states] = State.all

    assigns[:activity] = mock_model(Activity, {
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
    })
    render 'activities/edit'
  end

  it "should load the proper form" do
    response.should have_tag('h1', %r[Editing Activity])
  end
end
