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
  
  describe "accessor (:new_ta_category) for accepting a new Ta Category" do
    it "setter finds or creates a new ta category by name, adding it to the collection" do
      @activity.new_ta_category = 'New Ta Category'
      @activity.ta_categories.detect{|c| c.name == 'New Ta Category'}.should be_true
    end
    it "setter does not find or create if new ta category is blank" do
      TaCategory.should_not_receive(:find_or_create_by_name)
      @activity.new_ta_category = ''
    end
    it "getter returns the name of the new ta category" do
      @activity.new_ta_category = 'New Ta Category'
      @activity.new_ta_category.should == 'New Ta Category'
    end
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
  
  describe "named scopes" do
    it "can find all activities between a range of dates" do
      Activity.destroy_all
      july_activity = Activity.create!({
        :date_of_activity => Date.new(2010, 7, 1),
        :objective_id => 1,
        :activity_type_id => 2,
        :description => 'Descriptions in July',
        :intensity_level_id => 3
      })
      august_activity = Activity.create!({
        :date_of_activity => Date.new(2010, 8, 1),
        :objective_id => 4,
        :activity_type_id => 5,
        :description => 'Descriptions in August',
        :intensity_level_id => 6
      })
      july_activities = Activity.all_between(Date.new(2010, 7, 1), Date.new(2010, 7, 31))
      july_activities.should == [july_activity]
      august_activities = Activity.all_between(Date.new(2010, 8, 1), Date.new(2010, 8, 5))
      august_activities.should == [august_activity]
    end
  end

  describe "comparing and matching" do
    it "can determine if an activity matches by criteria" do
      obj1 = Objective.find_by_number 1
      assert obj1
      obj2 = Objective.find_by_number 2
      assert obj2
      act1 = Activity.create!({
        :date_of_activity => Date.new(2010, 8, 1),
        :objective => obj1,
        :activity_type_id => 5,
        :description => 'specific desc',
        :intensity_level_id => 6
      })

      assert act1.is_like?(:objective => obj1)
      assert !act1.is_like?(:objective => obj2)
      assert act1.is_like?(:objective => obj1, :description => "specific desc")
      assert !act1.is_like?(:objective => obj1, :description => "wrong desc")
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
  
  describe "csv load" do
    before(:all) do
      %w(Activity Criterium CollaboratingAgency Report ReportBreakdown State).each do |cls|
        cls.constantize.send(:destroy_all)
      end
      require 'db/seeds'
    end
    
    it "creates a new activity for each entry" do
      pre_count = Activity.count
      entry_count = File.new(File.join(Rails.root, 'spec/fixtures', 'activity_import.csv'), 'r').readlines.size - 2
      #FasterCSV.load(File.new(File.join(Rails.root, 'spec/fixtures', 'activity_import.csv'), 'r'))
      Activity.legacy_csv_import('spec/fixtures/activity_import.csv')
      Activity.count.should == pre_count + entry_count
    end
  end
end
