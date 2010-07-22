require 'spec_helper'

describe Activity do
  before(:each) do
    @valid_attributes = {
      :date_of_activity => Date.today,
      :objective => mock_model(Objective, {:name => 'Knowledge deveopment'}),
      :activity_type => "Conference",
      :states => [mock_model(State, {:name => 'Alabama', :region_id => 1})],
      :description => "value for description",
      :level_of_intensity => "Targeted/Specific"
    }
  end

  describe "before validation on save" do
    it "finds or creates the named objective" do
      activity = Activity.new(@valid_attributes)
    end
  end
end
