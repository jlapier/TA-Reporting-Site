require 'spec_helper'

describe ReportBreakdown do
  before(:each) do
    @report = mock_model(Report)
    @objective = mock_model(Objective)
    @valid_attributes = {
      :report => @report,
      :objective => @objective,
      :breakdown_type => "value for breakdown_type",
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
    report_breakdown.errors.on(:report).to_s.should =~ /can't be blank/
  end
  
  it "is not valid without an objective" do
    @valid_attributes.delete(:objective)
    report_breakdown = ReportBreakdown.new(@valid_attributes)
    report_breakdown.valid?.should be_false
    report_breakdown.errors.on(:objective).to_s.should =~ /can't be blank/
  end
  
  it "cannot duplicate a breakdown of the same objective for the same report" do
    ReportBreakdown.create!(@valid_attributes)
    report_breakdown = ReportBreakdown.new(@valid_attributes)
    report_breakdown.valid?.should be_false
    report_breakdown.errors.on(:objective_id).to_s.should =~ /has already been taken/
  end
end
