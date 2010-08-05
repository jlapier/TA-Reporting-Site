require 'spec_helper'

describe SummaryReport do
  before(:each) do
    @valid_attributes = {
      :name => "Monthly Report",
      :start_ytd => Date.new(2010, 1, 1),
      :start_period => Date.new(2010, 3, 1),
      :end_period => Date.new(2010, 3, 31),
      :report_title_format => "%B %Y<br/>Monthly Report"
    }
  end

  it "should create a new instance given valid attributes" do
    SummaryReport.create!(@valid_attributes)
  end


  describe "a valid summary report" do
    before(:each) do
      @summary_report = SummaryReport.create!(@valid_attributes)
    end

    it "should have a report title" do
      @summary_report.report_title.should == "March 2010<br/>Monthly Report"
      @summary_report.report_title_format = "%m/%y Report"
      @summary_report.report_title.should == "03/10 Report"
    end
    
    describe "when working with activities" do
      before(:each) do
        @i_l_intensive = mock_model IntensityLevel, :name => "Intensive"
        @i_l_general = mock_model IntensityLevel, :name => "General"
        
        @a_t_phone = mock_model ActivityType, :name => "phone"
        
        @or = mock_model State, :name => "Oregon", :abbreviation => "OR"
        @wa = mock_model State, :name => "Washington", :abbreviation => "WA"
        @id = mock_model State, :name => "Idaho", :abbreviation => "ID"
        

        @jan_act_mock = Activity.new :description => "jan activity", :date_of_activity => Date.new(2010, 1, 12), :states => [ @or, @id ],
          :intensity_level => @i_l_intensive, :activity_type => @a_t_phone
        @feb_act_mock = Activity.new :description => "feb activity", :date_of_activity => Date.new(2010, 2, 12), :states => [ @or ],
          :intensity_level => @i_l_general, :activity_type => @a_t_phone
        @march_act_mock = Activity.new :description => "march activity", :date_of_activity => Date.new(2010, 3, 9), :states => [ @or, @wa ],
          :intensity_level => @i_l_intensive, :activity_type => @a_t_phone

        Activity.should_receive(:all_between).with(Date.new(2010, 1, 1), Date.new(2010, 3, 31)).and_return(
          [@jan_act_mock, @feb_act_mock, @march_act_mock])
      end

      it "should get all activities for the year to date and the period" do
        @summary_report.ytd_activities.should == [@jan_act_mock, @feb_act_mock, @march_act_mock]
        @summary_report.period_activities.should == [@march_act_mock] 
      end

      it "should get all activities for an intensity level and activity type in ytd" do
        @summary_report.activities_by_type_for_ytd( { :activity_type => @a_t_phone, :intensity_level => @i_l_intensive } ).should == [ 
          @jan_act_mock, @march_act_mock ]
        @summary_report.activities_by_type_for_ytd( { :activity_type => @a_t_phone, :intensity_level => @i_l_general } ).should == [
          @feb_act_mock ]
      end

      it "should get all activities for an intensity level and activity type in period" do
        @summary_report.activities_by_type_for_period( { :activity_type => @a_t_phone, :intensity_level => @i_l_intensive } ).should == [ 
          @march_act_mock ]
        @summary_report.activities_by_type_for_period( { :activity_type => @a_t_phone, :intensity_level => @i_l_general } ).should == [ ]
      end

      it "should get all states for an intensity level and activity type in ytd" do
        @summary_report.states_by_type_for_ytd( { :activity_type => @a_t_phone, :intensity_level => @i_l_intensive } ).should == [ @id, @or, @wa ]
      end

      it "should get all states for an intensity level and activity type in period" do
        @summary_report.states_by_type_for_period( { :activity_type => @a_t_phone, :intensity_level => @i_l_intensive } ).should == [ @or, @wa ]
      end
    end
  end
end
