require 'spec_helper'

describe "/activities/index" do
  before(:each) do
    mock_objective = mock_model(Objective, {
        :name => "Obj 1", :display_name => "Obj 1", :number => 1, :id => 99 })

    assigns[:objectives] = [mock_objective]
    assigns[:ta_delivery_methods] = []
    assigns[:intensity_levels] = []

    assigns[:search] = ActivitySearch.new({})

    assigns[:activities] = [
      mock_model(Activity, {
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
    ]
    render 'activities/index'
  end

  it "should load a list of activities" do
    response.should have_tag('h1', %r[Activities])
  end
end
