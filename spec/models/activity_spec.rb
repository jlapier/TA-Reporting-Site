require 'spec_helper'

describe Activity do
  before(:each) do
    @valid_attributes = {
      :date_of_activity => Date.today,
      :objective_id => 1,
      :activity_type => "value for activity_type",
      :state_list => "value for state_list",
      :description => "value for description",
      :level_of_intensity => "value for level_of_intensity"
    }
  end

  it "should create a new instance given valid attributes" do
    Activity.create!(@valid_attributes)
  end
end
