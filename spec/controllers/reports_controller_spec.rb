require 'spec_helper'

describe ReportsController do

  before(:each) do
    controller.stub(:require_user).and_return(true)
  end

  describe ":index" do
    before(:each) do
      @report = mock_model(Report)
      Report.stub(:all).and_return([@report])
    end
    it "loads all reports as @reports" do
      Report.should_receive(:all).and_return([@report])
      get :index
      assigns[:reports].should == [@report]
    end
    it "renders the index template" do
      get :index
      response.should render_template("reports/index.html.erb")
    end
  end
  
  describe ":new" do
    before(:each) do
      @report = mock_model(Report).as_new_record
      Report.stub(:new).and_return(@report)
    end
    it "instantiates a new report as @report" do
      Report.should_receive(:new).and_return(@report)
      get :new
      assigns[:report].should == @report
    end
    it "renders the new template" do
      get :new
      response.should render_template("reports/new.html.erb")
    end
  end
  
  describe ":edit, :id => integer" do
    before(:each) do
      @report = mock_model(Report)
      Report.stub(:find).and_return(@report)
    end
    it "loads a report as @report from params[:id]" do
      Report.should_receive(:find).with('1').and_return(@report)
      get :edit, :id => 1
      assigns[:report].should == @report
    end
    it "loads all objectives as @objectives" do
      objective = mock_model(Objective)
      Objective.should_receive(:all).and_return([objective])
      get :edit, :id => 1
      assigns[:objectives].should == [objective]
    end
    it "renders the edit template" do
      get :edit, :id => 1
      response.should render_template("reports/edit.html.erb")
    end
  end
  
  describe ":create, :report => {}" do
    before(:each) do
      @report = mock_model(Report, {
        :save => nil,
        :id => 1111
      })
      Report.stub(:new).and_return(@report)
    end
    it "instantiates a new report as @report from params[:report]" do
      Report.should_receive(:new).with({
        'name' => 'Q1 - 2010'
      }).and_return(@report)
      post :create, :report => {:name => 'Q1 - 2010'}
      assigns[:report].should == @report
    end
    it "saves the new report" do
      @report.should_receive(:save)
      post :create
    end
    context "save succeeds :)" do
      before(:each) do
        @report.stub(:save).and_return(true)
      end
      it "sets a flash[:notice]" do
        post :create
        flash[:notice].should_not be_nil
      end
      it "redirects to update the new report" do
        post :create
        response.should redirect_to edit_report_path(@report.id)
      end
    end
    context "save fails :(" do
      before(:each) do
        @report.stub(:save).and_return(false)
      end
      it "renders the new template" do
        post :create
        response.should render_template("reports/new.html.erb")
      end
    end
  end
  
  describe ":export_all, :report => {}" do
    before(:each) do
      @report = mock_model(Report, {
        :export => nil,
        :export_filename => "Q1 - 2010 TA Activity Report.csv",
        :csv => "one,two,three\nfour,five,six\n"
      })
      Report.stub(:new).and_return(@report)
    end
    it "instantiates a new report as @report from params[:report]" do
      Report.should_receive(:new).and_return(@report)
      post :export_all, :report => {:start_month => 1, :start_year => 2010}
      assigns[:report].should == @report
    end
    context ":report => {:start_month => MM, :start_year => YYYY}" do
      before(:each) do
        @report.stub({
          :save => nil,
          :export_filename => "Q1 - 2010 TA Activity Report.csv",
          :export => nil,
          :csv => "one,two,three\nfour,five,six\n"
        })
      end
      it "exports the custom report as csv download" do
        @report.should_receive(:export)
        @report.should_receive(:csv).and_return("one,two,three\nfour,five,six\n")
        controller.should_receive(:send_data).with("one,two,three\nfour,five,six\n", {
          :type => "text/csv",
          :disposition => "attachment",
          :filename => "Q1 - 2010 TA Activity Report.csv"
        })
        post :export_all, :id => @report.id, :report => {
          :start_period => "January 1, 2010",
          :end_period => "March 31, 2010"
        }
      end
    end
  end
end
