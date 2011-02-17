require 'spec_helper'

describe ReportBreakdown do
  before(:each) do
    @report = mock_model(Report)
    @objective = mock_model(Objective, {
      :number => 1
    })
    @valid_attributes = {
      :report => @report,
      :objective => @objective,
      :breakdown_type => "GrantActivity",
      :include_states => false
    }
  end

  it "should create a new instance given valid attributes" do
    ReportBreakdown.create!(@valid_attributes)
  end
  
  %w( report objective ).each do |obj|
    it "belongs to #{obj}" do
      report_breakdown = ReportBreakdown.new
      report_breakdown.respond_to?("create_#{obj}".to_sym).should be_true
    end
  end
  
  it "is not valid without a report" do
    @valid_attributes.delete(:report)
    report_breakdown = ReportBreakdown.new(@valid_attributes)
    report_breakdown.valid?.should be_false
    report_breakdown.errors[:report].first.should =~ /can't be blank/
  end
  
  it "is not valid without an objective" do
    @valid_attributes.delete(:objective)
    report_breakdown = ReportBreakdown.new(@valid_attributes)
    report_breakdown.valid?.should be_false
    report_breakdown.errors[:objective].first.should =~ /can't be blank/
  end
  
  it "cannot duplicate a breakdown of the same objective for the same report" do
    ReportBreakdown.create!(@valid_attributes)
    report_breakdown = ReportBreakdown.new(@valid_attributes)
    report_breakdown.valid?.should be_false
    report_breakdown.errors[:objective_id].first.should =~ /has already been taken/
  end
  
  describe "accessing activities" do
    before(:each) do
      @start = Date.new(2010, 7, 1)
      @end = Date.new(2010, 7, 31)
      @obj1 = mock_model(Objective, {:number => 1, :name => 'Knowledge Development'})
      @act1 = mock_model(Activity, {:objective => @obj1, :grant_activities => [mock_model(GrantActivity, {:name => 'Some Activity Type'})]})
      @report.stub_chain(:grouped_activities, :[]).with(1).and_return([@act1])
      @report.stub(:start_period= => nil, :end_period= => nil)
    end
    context "self[:breakdown_type] is not blank" do
      it "#activities returns activities of a single objective, in a hash w/ multiple key/value pairs, eg: {'Information Request' => [activitiesA], 'Conference' => [activitiesB]} " do
        report_breakdown = ReportBreakdown.create!(@valid_attributes)
        report_breakdown.activities(@start, @end).should == {'Some Activity Type' => [@act1]}
      end
    end
    context "self[:breakdown_type] is blank" do
      it "#activities returns activities of a single objective, in a hash w/ one key/value pair, where key is nil ie: {'' => [all_activities]}" do
        @valid_attributes.delete(:breakdown_type)
        report_breakdown = ReportBreakdown.create!(@valid_attributes)
        report_breakdown.activities(@start, @end).should == {'' => [@act1]}
      end
    end
    it "knows if it has activities between a start and end period" do
      report_breakdown = ReportBreakdown.create!(@valid_attributes)
      report_breakdown.has_activities_between(@start, @end).should be_true
    end
    it "knows if it doesn't have activities between a start and end period" do
      @report.stub_chain(:grouped_activities, :[]).with(1).and_return(nil)
      report_breakdown = ReportBreakdown.create!(@valid_attributes)
      report_breakdown.has_activities_between(@start, @end).should be_false
    end
  end
end
