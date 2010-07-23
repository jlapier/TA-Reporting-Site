require 'spec_helper'

describe Activity do
  before(:each) do
    @valid_attributes = {
      :date_of_activity => Date.today,
      :objective => mock_model(Objective, {
        :name => 'Knowledge deveopment'
      }),
      :activity_type => mock_model(ActivityType, {
        :name => 'Information request'
      }),
      :states => [mock_model(State, {:name => 'Alabama', :region_id => 1})],
      :description => "value for description",
      :intensity_level => mock_model(IntensityLevel, {
        :name => "Targeted/Specific"
      })
    }
    @activity = Activity.new
  end

  describe "before validation on save" do
    it "removes any state_ids referencing a region" do
      State.destroy_all
      region = State.create({
        :id => 1,
        :name => 'Western'
      })
      state = State.create({
        :id => 2,
        :region_id => 1,
        :name => 'Oregon'
      })
      
      @valid_attributes.delete(:states)
      @valid_attributes.merge!({
        :state_ids => [1, 2]
      })
      activity = Activity.new(@valid_attributes)
      activity.save
      activity.state_ids.should == [2]
    end
  end
  
  describe "associations" do
    %w(objective activity_type intensity_level).each do |assoc|
      it "belongs to #{assoc}" do
        @activity.respond_to?(assoc.to_sym).should be_true
        @activity.respond_to?("build_#{assoc}".to_sym).should be_true
      end
    end
    %w(states ta_categories).each do |assoc|
      it "has and belongs to many #{assoc}" do
        @activity.respond_to?(assoc.to_sym).should be_true
        @activity.send(assoc.to_sym).respond_to?(:build).should be_true
      end
    end
  end
end
