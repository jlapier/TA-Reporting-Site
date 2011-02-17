require 'spec_helper'

describe ActivitySearch do
  before(:all) do
    Activity.destroy_all
    @jan_shared = Activity.create!({
      :date_of_activity => Date.new(2010, 1, 1),
      :objective_id => 1,
      :intensity_level_id => 2,
      :ta_delivery_method_id => 3,
      :description => "January activity (w/ shared criteria)"
    })
    @jan = Activity.create!({
      :date_of_activity => Date.new(2010, 1, 2),
      :objective_id => 10,
      :intensity_level_id => 11,
      :ta_delivery_method_id => 12,
      :description => "January activity"
    })
    @feb_one = Activity.create!({
      :date_of_activity => Date.new(2010, 2, 1),
      :objective_id => 4,
      :intensity_level_id => 5,
      :ta_delivery_method_id => 6,
      :description => "February activity one"
    })
    @mar = Activity.create!({
      :date_of_activity => Date.new(2010, 3, 1),
      :objective_id => 7,
      :intensity_level_id => 8,
      :ta_delivery_method_id => 9,
      :description => "March activity"
    })
    @apr_shared = Activity.create!({
      :date_of_activity => Date.new(2010, 4, 1),
      :objective_id => 1,
      :intensity_level_id => 2,
      :ta_delivery_method_id => 3,
      :description => "April activity (w/ shared criteria)"
    })
    @feb_two = Activity.create!({
      :date_of_activity => Date.new(2010, 2, 2),
      :objective_id => 7,
      :intensity_level_id => 8,
      :ta_delivery_method_id => 9,
      :description => "February activity two"
    })
    # @jan_shared
    @jan_search_one = ActivitySearch.new({
      :start_date => Date.new(2010, 1, 1),
      :end_date => Date.new(2010, 1, 31),
      :objective_id => 1,
      :intensity_level_id => 2,
      :ta_delivery_method_id => 3,
      :keywords => "January activity (w/ shared criteria)"
    })
    @jan_search_two = ActivitySearch.new({
      :start_date => Date.new(2010, 1, 1),
      :end_date => Date.new(2010, 1, 31)
    })
    @shared_search = ActivitySearch.new({
      :objective_id => 1,
      :intensity_level_id => 2,
      :ta_delivery_method_id => 3
    })
    @jan_mar_search = ActivitySearch.new({
      :start_date => Date.new(2010, 1, 1),
      :end_date => Date.new(2010, 3, 30)
    })
    @partial_description = ActivitySearch.new({
      :keywords => "shared"
    })
    @blank_start = ActivitySearch.new({
      :start_date => "",
      :keywords => "shared"
    })
    @blank_end = ActivitySearch.new({
      :end_date => "",
      :keywords => "shared"
    })
    @funky_start = ActivitySearch.new({
      :start_date => "January 1, 2010",
      :keywords => "one"
    })
    @funky_end = ActivitySearch.new({
      :end_date => "February 3, 2010",
      :keywords => "one"
    })
  end
  after(:all) do
    Activity.destroy_all
  end
  it "builds conditions to find activities" do
    @jan_search_one.activities.should == [@jan_shared]
    @jan_search_two.activities.should == [@jan, @jan_shared]
    @shared_search.activities.should == [@apr_shared, @jan_shared]
    @jan_mar_search.activities.should == [@mar, @feb_two, @feb_one, @jan, @jan_shared]
    @partial_description.activities.should == [@apr_shared, @jan_shared]
  end
  it "has a default start date" do
    @blank_start.activities.should == [@apr_shared, @jan_shared]
  end
  it "has a default end date" do
    @blank_end.activities.should == [@apr_shared, @jan_shared]
  end
  it "turns string dates into Date objects" do
    @funky_start.activities.should == [@feb_one]
    @funky_end.activities.should == [@feb_one]
  end
end
