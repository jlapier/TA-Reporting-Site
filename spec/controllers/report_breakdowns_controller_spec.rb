require 'spec_helper'

describe ReportBreakdownsController do

  before(:each) do
    controller.stub(:require_user)
  end

  describe "AJAX :create, :report_breakdown => {}" do
    before(:each) do
      @report = mock_model(Report)
      @report_breakdown = mock_model(ReportBreakdown, {
        :save => nil
      }).as_new_record
      Report.stub(:find).and_return(@report)
      ReportBreakdown.stub(:new).and_return(@report_breakdown)
    end
    it "instantiates a new report breakdown as @new_report_breakdown" do
      ReportBreakdown.should_receive(:new).with({
        'report' => @report,
        'objective_id' => '1',
        'breakdown_type' => 'ActivityType',
        'include_states' => '1'
      }).and_return(@report_breakdown)
      xhr :post, :create, :report_breakdown => {
        :objective_id => '1',
        :breakdown_type => 'ActivityType',
        :include_states => '1'
      }, :report_id => @report.id
      assigns[:new_report_breakdown].should == @report_breakdown
    end
    it "saves @new_report_breakdown storing result in @saved" do
      @report_breakdown.should_receive(:save).and_return(false)
      xhr :post, :create, :report_id => @report.id, :report_breakdown => {}
      assigns[:saved].should == false
    end
    it "renders the create rjs template" do
      xhr :post, :create, :report_id => @report.id, :report_breakdown => {}
      response.should render_template("create")
    end
  end

end
