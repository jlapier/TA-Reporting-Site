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
      region = mock_model(State, {
        :id => 1,
        :name => 'Western',
        :quoted_id => "1"
      })
      state = mock_model(State, {
        :id => 2,
        :region_id => 1,
        :name => 'Oregon',
        :quoted_id => "2"
      })
      State.stub(:find).and_return([region, state])
      State.stub_chain(:regions, :options).and_return([region])
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
  
  describe "csv dump" do
    fixtures :activities, :criteria, :states, :collaborating_agencies, :activities_states, :activities_ta_categories, :activities_collaborating_agencies
    before(:each) do
      @activities = Activity.all
      @csv = FasterCSV.dump(@activities)
    end
    it "has a meta row first" do
      @csv.split("\n")[0].should == 'class,Activity'
    end
    it "has a header row second" do
      @csv.split("\n")[1].should == 'Date,Objective,Type,Intensity,TA Categories,Agencies,States'
    end
    it "dumps object data to remaining rows" do
      body = @csv.split("\n")[2..-1]
      c = 0
      @activities.each do |activity|
        body[c].should == "#{activity.date_of_activity}," + 
                          "#{activity.objective.number}: #{activity.objective.name}," + 
                          "#{activity.activity_type.name}," + 
                          "#{activity.intensity_level.name}," + 
                          "#{activity.ta_categories.collect{|t|t.name}.join('; ')}," + 
                          "#{activity.collaborating_agencies.collect{|a| a.name}.join('; ')}," + 
                          "#{activity.states.collect{|s|"#{s.name} (#{s.abbreviation})"}.join('; ')}"
        c += 1
      end
    end
  end
end
