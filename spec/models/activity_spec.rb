require 'spec_helper'

describe Activity do  
  before(:all) do
    [Activity, Criterium, State, CollaboratingAgency].each{|klass| klass.destroy_all}
    Rspec.configure{|config| config.use_transactional_fixtures = false}
  end
  after(:all) do
    Rspec.configure{|config| config.use_transactional_fixtures = true}
    [Activity, Criterium, State, CollaboratingAgency].each{|klass| klass.destroy_all}
  end            

  fixtures :activities, :criteria, :states, :collaborating_agencies, :activities_states, :activities_ta_categories, 
            :activities_collaborating_agencies
  
  before(:each) do
    @valid_attributes = {
      :date_of_activity => Date.today,
      :objective => mock_model(Objective, {
        :name => 'Knowledge deveopment'
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
        :quoted_id => "1",
        :record_timestamps => nil
      })
      state = mock_model(State, {
        :id => 2,
        :region_id => 1,
        :name => 'Oregon',
        :quoted_id => "2",
        :record_timestamps => nil
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
    %w(objective ta_delivery_method intensity_level).each do |assoc|
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
        :ta_delivery_method_id => 2,
        :description => 'Descriptions in July',
        :intensity_level_id => 3
      })
      august_activity = Activity.create!({
        :date_of_activity => Date.new(2010, 8, 1),
        :objective_id => 4,
        :ta_delivery_method_id => 5,
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
      ga1 = GrantActivity.find_by_name "Budget Management"
      assert ga1
      ga2 = GrantActivity.find_by_name "Core Meetings"
      assert ga2
      ga3 = GrantActivity.find_by_name "Advisory Committee"
      assert ga3
      act1 = Activity.create!({
        :date_of_activity => Date.new(2010, 8, 1),
        :objective => obj1,
        :ta_delivery_method_id => 5,
        :description => 'specific desc',
        :intensity_level_id => 6,
        :grant_activities => [ga1, ga2]
      })

      assert act1.is_like?(:objective => obj1)
      assert !act1.is_like?(:objective => obj2)
      assert act1.is_like?(:objective => obj1, :description => "specific desc")
      assert !act1.is_like?(:objective => obj1, :description => "wrong desc")
      assert act1.is_like?(:grant_activity => ga1)
      assert act1.is_like?(:grant_activity => ga2)
      assert !act1.is_like?(:grant_activity => ga3)
      assert act1.is_like?(:grant_activities => [ga1, ga2])
    end
  end
  
  describe "Activity.like some_attr_or_relation_name => some_value" do
    before(:all) do
      @obj1 = Objective.find_by_number 1
      @obj2 = Objective.find_by_number 2
      @ga1 = GrantActivity.find_by_name "Budget Management"
      @ga2 = GrantActivity.find_by_name "Core Meetings"
      @ga3 = GrantActivity.find_by_name "Advisory Committee"
      @ta = TaCategory.find_by_name "Graduation rates"
      @obj1.should_not be_nil
      @obj2.should_not be_nil
      @ga1.should_not be_nil
      @ga2.should_not be_nil
      @ga3.should_not be_nil
      @ta.should_not be_nil
      @act1 = Activity.create!({
        :date_of_activity => Date.new(2010, 8, 1),
        :objective => @obj1,
        :ta_delivery_method_id => 5,
        :description => 'specific desc',
        :intensity_level_id => 6,
        :grant_activities => [@ga1, @ga2],
        :ta_categories => [@ta]
      })
      @obj1_activity = Activity.find_by_objective_id(@obj1.id)
      @ga1_activity = Activity.all.select{|act| act.grant_activities.include?(@ga1)}.first
      @ta_activity = Activity.all.select{|act| act.ta_categories.include?(@ta)}.first
      @obj1_activity.should_not be_nil
      @ga1_activity.should_not be_nil
      @ta_activity.should_not be_nil
    end
    it "finds activities based on attributes" do
      Activity.like(:objective_id => @obj1.id).all.should include @act1
    end
    it "finds activities associated w/ some grant_activity" do
      Activity.like(:grant_activity => @ga1).all.should include @act1
    end
    it "finds activities associated w/ some ta_category" do
      Activity.like(:ta_category => @ta).all.should include @act1
    end
    it "finds activities associated w/ some ta_category and some grant_activity and based on attributes" do
      Activity.like({
        :ta_category => @ta,
        :grant_activity => @ga1,
        :objective_id => @obj1
      }).all.should include @act1
    end
  end
  
  describe "FasterCSV integration" do
    it "provides objects w/ csv_headers" do
      activity = Activity.new
      activity.csv_headers.should eql [
        'Date',
        'Objective',
        'TA Delivery Method',
        'Grant Activities',
        'Intensity',
        'TA Categories',
        'Description of Activity',
        'Agencies',
        'States'
      ]
    end
    it "provides objects w/ csv_dump" do
      date = Date.today
      objective = mock_model(Objective, {:number => 1, :name => 'Work'})
      intensity_level = mock_model(IntensityLevel, {:name => 'High'})
      ta_delivery_method = mock_model(TaDeliveryMethod, {:name => 'Fax'})
      ta_categories = [mock_model(TaCategory, {:name => 'Category'})]
      collaborating_agencies = [mock_model(CollaboratingAgency, {:name => 'Agency'})]
      states = [mock_model(State, {:name => 'Oregon', :abbreviation => 'OR'})]
      grant_activities = [mock_model(GrantActivity, {:name => 'Conference'})]
      activity = Activity.new({
        :date_of_activity => date,
        :objective => objective,
        :ta_delivery_method => ta_delivery_method,
        :intensity_level => intensity_level,
        :ta_categories => ta_categories,
        :description => "test desc",
        :collaborating_agencies => collaborating_agencies,
        :states => states,
        :grant_activities => grant_activities
      })
      activity.csv_dump(activity.csv_headers).should eql [
        date,
        "#{objective.number}: #{objective.name}",
        'Fax',
        grant_activities.collect{|ga| ga.name}.join('; '),
        intensity_level.name,
        ta_categories.collect{|ta| ta.name}.join('; '),
        'test desc',
        collaborating_agencies.collect{|a| a.name}.join('; '),
        states.collect{|s| "#{s.name} (#{s.abbreviation})"}.join('; ')
      ]
    end    
  end
end
