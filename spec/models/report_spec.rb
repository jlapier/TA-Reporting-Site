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
  
  describe "setting export periods" do
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
  end
  
  describe "export filename formatting, #export_filename" do
    before(:each) do
      @report = Report.new(:name => 'Q1 - 2010')
      @suffix = "TA Activity Report.csv"
    end
    context "if period is set" do
      it "uses 'YYYY-MM TA Activity Report.csv'" do
        @report.start_month = 1
        @report.start_year = 2010
        @report.export_filename.should == "2010-01 Q1 - 2010 #{@suffix}"
      end
    end
    context "if start and end periods are set" do
      it "uses 'Month YYYY - Month YYYY TA Activity Report.csv'" do
        @report.start_month = 1
        @report.start_year = 2010
        @report.end_month = 3
        @report.end_year = 2010
        @report.export_filename.should == "2010 January - 2010 March Q1 - 2010 #{@suffix}"
      end
    end
    context "if no periods are set" do
      it "uses '@name TA Activity Report.csv'" do
        @report.export_filename.should == "Q1 - 2010 #{@suffix}"
      end
    end
  end
  
  describe "exporting activities in csv format, #csv_export" do
    before(:each) do
      @objective = mock_model(Objective, {
        :number => 1,
        :name => 'Knowledge development'
      })
      @activity_type = mock_model(ActivityType, {
        :name => 'Conference'
      })
      @intensity_level = mock_model(IntensityLevel, {
        :name => 'Intensive'
      })
      @ta_category = mock_model(TaCategory, {
        :name => 'SLDS'
      })
      @agency = mock_model(CollaboratingAgency, {
        :name => 'WRRC'
      })
      @state = mock_model(State, {
        :name => 'Oregon',
        :abbreviation => 'OR'
      })
      ta_categories = [@ta_category]
      collaborating_agencies = [@agency]
      states = [@state]
      activity_stubs = {
        :objective => @objective,
        :activity_type => @activity_type,
        :intensity_level => @intensity_level,
        :ta_categories => [@ta_category],
        :collaborating_agencies => [@agency],
        :states => [],
        :csv_headers => [
          'Date',
          'Objective',
          'Type',
          'Intensity',
          'TA Categories',
          'Agencies',
          'States'
        ],
        :csv_dump => [
          Time.now.months_ago(2),
          "#{@objective.number}: #{@objective.name}",
          @activity_type.name,
          @intensity_level.name,
          ta_categories.collect{|ta| ta.name}.join('; '),
          collaborating_agencies.collect{|a| a.name}.join('; '),
          states.collect{|s| "#{s.name} (#{s.abbreviation})"}.join('; ')
        ]
      }
      @report = Report.new(:name => 'Q1 - 2010', :start_month => 7, :start_year => 2010)
      date = Time.now.months_ago(2).freeze
      @activity_one = mock_model(Activity, activity_stubs.merge!({
        :date_of_activity => date
      }))
      @activities = [
        @activity_one
      ]
      Activity.stub(:all_between).and_return(@activities)
    end
    it "updates @csv with dumped activities" do
      @report.export
      @report.csv.should == "class,Activity\n"+
        "Date,Objective,Type,Intensity,TA Categories,Agencies,States\n"+
        "#{@activity_one.date_of_activity},#{@objective.number}: #{@objective.name},"+
        "#{@activity_type.name},#{@intensity_level.name},#{@ta_category.name},"+
        "#{@agency.name},#{@state.name} (#{@state.abbreviation})\n"
    end
  end
end
