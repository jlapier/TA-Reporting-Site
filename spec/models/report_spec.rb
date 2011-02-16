require 'spec_helper'

describe Report do
  before(:each) do
    @valid_attributes = {
      :name => "value for name"
    }
  end
  
  it "has many report breakdowns" do
    report = Report.new
    report.respond_to?(:report_breakdowns).should be_true
    report.report_breakdowns.respond_to?(:build).should be_true
  end

  it "should create a new instance given valid attributes" do
    Report.create!(@valid_attributes)
  end
  
  it "is not valid without a name" do
    report = Report.new
    report.valid?.should be_false
    report.errors.on(:name).to_s.should =~ /can't be blank/
  end
  
  it "is not valid with a non-unique name" do
    Report.create!(@valid_attributes)
    report = Report.new(@valid_attributes)
    report.valid?.should be_false
    report.errors.on(:name).to_s.should =~ /has already been taken/
  end
  
  describe "export periods" do
    before(:each) do
      @report = Report.new
      @report.dates = {
        :start_month => 8,
        :start_year => 2010,
        :end_month => 8,
        :end_year => 2010
      }
    end
    it "can set all dates at once" do
      @report.start_month.should == 8
      @report.start_year.should == 2010
      @report.end_month.should == 8
      @report.end_year.should == 2010
    end
    it "groups start and end dates into periods" do
      @report.start_period.should == Date.new(2010, 8, 1)
      @report.end_period.should == Date.new(2010, 8, 31)
    end
    it "can set start_period directly" do
      @report.start_period = Date.new(2010, 7, 1)
      @report.start_year.should == 2010
      @report.start_month.should == 7
    end
    it "can set end_period directly" do
      @report.end_period = Date.new(2010, 8, 1)
      @report.end_year.should == 2010
      @report.end_month.should == 8
    end
    describe "loading activities" do
      before(:each) do
        @obj1 = mock_model(Objective, {:number => 1, :name => 'Knowledge Development'})
        @obj2 = mock_model(Objective, {:number => 2, :name => 'Provide TA'})
        @obj3 = mock_model(Objective, {:number => 3, :name => 'Leadership and Coordination'})
        @obj4 = mock_model(Objective, {:number => 4, :name => 'Evaluate and Manage (includes Advisory)'})
        @act1 = mock_model(Activity, {:objective => @obj1})
        @act2 = mock_model(Activity, {:objective => @obj2})
        @act3 = mock_model(Activity, {:objective => @obj3})
        @act4 = mock_model(Activity, {:objective => @obj4})
        @activities = [@act1, @act2, @act3, @act4]
        Activity.stub(:all_between).and_return(@activities)
      end
      it "collects all activities between the start and end period" do
        Activity.should_receive(:all_between).with(@report.start_period, @report.end_period)
        @report.activities
      end
      it "groups activities by objective.number" do
        @report.grouped_activities.should == {
          1 => [@act1],
          2 => [@act2],
          3 => [@act3],
          4 => [@act4]
        }
      end
      it "knows whether it has found activities with a given objective" do
        Activity.stub(:all_between).and_return(@activities - [@act3, @act4])
        @report.has_activities_like({:objective => @obj1}).should be_true
        @report.has_activities_like({:objective => @obj3}).should be_false
      end
    end
  end
  
  describe "default periods" do
    before(:each) do
      @report = Report.new
    end
    it "sets default start_year as current year" do
      @report.start_year.should eql Date.current.year
    end
    it "sets default start_month as January" do
      @report.start_month.should eql 1
    end
    it "sets default end_year as current year" do
      @report.end_year.should eql Date.current.year
    end
    it "sets default end_month as current month - 1" do
      @report.end_month.should eql Date.current.month - 1
    end
  end
  
  describe "export filename formatting, #export_filename" do
    before(:each) do
      @report = Report.new(:name => 'Q1 - 2010')
      @suffix = "TA Activity Report"
    end
    it "uses 'Month YYYY - Month YYYY TA Activity Report'" do
      @report.start_month = 1
      @report.start_year = 2010
      @report.end_month = 3
      @report.end_year = 2010
      @report.export_filename.should == "2010 January - 2010 March Q1 - 2010 #{@suffix}"
    end
  end
  
  describe "exporting activities" do
    before(:each) do
      @objective = mock_model(Objective, {
        :number => 1,
        :name => 'Knowledge development'
      }).as_null_object
      @grant_activity = mock_model(GrantActivity, {
        :name => 'Conference'
      }).as_null_object
      @intensity_level = mock_model(IntensityLevel, {
        :name => 'Intensive'
      }).as_null_object
      @ta_category = mock_model(TaCategory, {
        :name => 'SLDS'
      }).as_null_object
      @agency = mock_model(CollaboratingAgency, {
        :name => 'WRRC'
      }).as_null_object
      @state = mock_model(State, {
        :name => 'Oregon',
        :abbreviation => 'OR'
      }).as_null_object
      ta_categories = [@ta_category]
      collaborating_agencies = [@agency]
      states = [@state]
      State.stub(:find).and_return([@state])
      activity_stubs = {
        :objective => @objective,
        :intensity_level => @intensity_level,
        :ta_categories => [@ta_category],
        :collaborating_agencies => [@agency],
        :states => [@state],
        :state_ids => [@state.id],
        :grant_activities => [@grant_activity] #,
        #:csv_headers => [
        #  'Date',
        #  'Objective',
        #  'Type',
        #  'Intensity',
        #  'TA Categories',
        #  'Agencies',
        #  'States'
        #],
        #:csv_dump => [
        #  Time.now.months_ago(2),
        #  "#{@objective.number}: #{@objective.name}",
        #  @activity_type.name,
        #  @intensity_level.name,
        #  ta_categories.collect{|ta| ta.name}.join('; '),
        #  collaborating_agencies.collect{|a| a.name}.join('; '),
        #  states.collect{|s| "#{s.name} (#{s.abbreviation})"}.join('; ')
        #]
      }
      @report = Report.new(:name => 'Q1 - 2010', :start_month => 7, :start_year => 2010)
      date = Time.now.months_ago(2).freeze
      State.stub_chain(:regions, :options, :collect).and_return([])
      @activity_one = Activity.create(activity_stubs.merge!({
        :date_of_activity => date
      }))
      @activities = [
        @activity_one
      ]
      Activity.stub(:all_between).and_return(@activities)
    end
    it "export(:csv) updates @csv with dumped activities" do
      @report.to_csv
      @report.csv.should == "" +   # "class,Activity\n"+
        "Date,Objective,TA Delivery Method,Grant Activities,Intensity,TA Categories,Description of Activity,Agencies,States\n"+
        "#{@activity_one.date_of_activity},#{@objective.number}: #{@objective.name},\"\","+
        "#{@grant_activity.name},#{@intensity_level.name},#{@ta_category.name},,"+
        "#{@agency.name},#{@state.name} (#{@state.abbreviation})\n"
    end
  end
end
