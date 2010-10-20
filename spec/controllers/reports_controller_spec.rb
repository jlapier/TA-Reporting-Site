require 'spec_helper'

describe ReportsController do

  before(:each) do
    controller.stub(:require_user).and_return(true)
  end

  describe ":index" do
    before(:each) do
      @report = mock_model(Report)
      Report.stub(:find).and_return([@report])
    end
    it "loads all reports as @reports" do
      Report.should_receive(:find).and_return([@report])
      get :index
      assigns[:reports].should == [@report]
    end
    it "loads all summary reports as @summary_reports" do
      SummaryReport.should_receive(:find).and_return([@summary_report])
      get :index
      assigns[:summary_reports].should eql [@summary_reports]
    end
    it "loads all objectives as @objectives" do
      objective = mock_model(Objective)
      Objective.should_receive(:find).and_return([objective])
      get :index
      assigns[:objectives].should == [objective]
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
      get :new
      assigns[:report].should == @report
    end
    it "renders the new template" do
      get :new
      response.should render_template("reports/new.html.erb")
    end
  end
  
  describe ":show, :id => integer, :summary_report_id => optional:integer" do
    before(:each) do
      @report = mock_model(Report, {
        :dates= => nil,
        :start_period => Date.new(2010, 1),
        :end_period => Date.new(2010, 6)
      })
      @summary_report = mock_model(SummaryReport, {
        :start_period => Date.new(2010, 5, 1),
        :end_period => Date.new(2010, 5, 30)
      })
    end
    context "report is found" do
      before(:each) do
        Report.should_receive(:find).once.and_return(@report)
      end
      it "loads a report as @report from params[:id]" do
        get :show, :id => 1, :summary_report_id => 1
        assigns[:report].should == @report
      end
      it "renders the show template" do
        get :show, :id => 1
        response.should render_template("reports/show.html.erb")
      end
    end
    context "report is not found" do
      before(:each) do
        Report.should_receive(:find).once.and_raise(ActiveRecord::RecordNotFound)
      end
      it "sets a flash[:notice]" do
        get :show, :id => 0
        flash[:notice].should_not be_nil
      end
      it "redirects to the reports page" do
        get :show, :id => 0
        response.should redirect_to reports_path
      end
    end
    context "summary report is found" do
      before(:each) do
        Report.should_receive(:find).once.and_return(@report)
        SummaryReport.should_receive(:find).once.and_return(@summary_report)
      end
      it "loads a summary report from params[:summary_report_id]" do
        get :show, :id => 1, :summary_report_id => 1
        assigns[:summary_report].should eql @summary_report
      end
      it "updates report periods from summary report periods" do
        @report.should_receive(:dates=).with({
          :start_year => 2010,
          :start_month => 5,
          :end_year => 2010,
          :end_month => 5
        })
        get :show, :id => 1, :summary_report_id => 1
      end
      it "loads all IntensityLevels" do
        intensity_level = mock_model(IntensityLevel)
        IntensityLevel.should_receive(:all).and_return([intensity_level])
        get :show, :id => 1, :summary_report_id => 1
        assigns[:intensity_levels].should eql [intensity_level]
      end
      it "loads all GrantActivities" do
        grant_activity = mock_model(GrantActivity)
        GrantActivity.should_receive(:all).and_return([grant_activity])
        get :show, :id => 1, :summary_report_id => 1
        assigns[:grant_activities].should eql [grant_activity]
      end
    end
    context "summary report is not found or is not requested" do
      before(:each) do
        Report.should_receive(:find).once.and_return(@report)
        SummaryReport.should_receive(:find).once.and_raise(ActiveRecord::RecordNotFound)
        stub_flash_sweeper
      end
      it "is not found so sets flash.now[:notice]" do
        get :show, :id => 0, :summary_report_id => 0
        flash[:notice].should_not be_nil
      end
      it "is not requested so sets a flash.now[:notice]" do
        get :show, :id => 0
        flash[:notice].should_not be_nil
      end
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
  
  describe ":update, :id => integer, :report => {}" do
    before(:each) do
      @report = mock_model(Report, {
        :update_attributes => nil
      })
      Report.stub(:find).and_return(@report)
    end
    it "loads a report as @report from params[:id]" do
      Report.should_receive(:find).and_return(@report)
      put :update, :id => @report.id
      assigns[:report].should == @report
    end
    it "updates @report" do
      @report.should_receive(:update_attributes).with({
        'name' => 'New name'
      })
      put :update, :id => @report.id, :report => {:name => 'New name'}
    end
    context "update succeeds :)" do
      before(:each) do
        @report.stub(:update_attributes).and_return(true)
      end
      it "sets flash[:notice]" do
        put :update, :id => @report.id
        flash[:notice].should_not be_nil
      end
      it "redirects to the reports page" do
        put :update, :id => @report.id
        response.should redirect_to reports_path
      end
    end
    context "update fails :(" do
      before(:each) do
        @report.stub(:update_attributes).and_return(false)
      end
      it "renders the edit template" do
        put :update, :id => @report.id
        response.should render_template("reports/edit.html.erb")
      end
    end
  end
  
  describe ":destroy, :id => integer" do
    before(:each) do
      @report = mock_model(Report, {
        :name => "doomed report"
      })
      Report.stub(:destroy).and_return(@report)
    end
    it "destroys the report of params[:id]" do
      Report.should_receive(:destroy).with(@report.id.to_s).and_return(@report)
      delete :destroy, :id => @report.id
    end
    it "sets a flash[:notice]" do
      delete :destroy, :id => @report.id
      flash[:notice].should_not be_nil
    end
    it "redirects to the reports page" do
      delete :destroy, :id => @report.id
      response.should redirect_to reports_path
    end
  end
  
  describe ":download, :start_month => MM, start_year => YYYY, :end_month => MM, :end_year => YYYY" do
    before(:each) do
      @report = mock_model(Report, {
        :dates= => nil,
        :export => nil,
        :name => "Q1 - 2010",
        :csv => nil,
        :activities => [],
        :start_period => Date.new(2010, 1),
        :end_period => Date.new(2010, 6)
      })
      Report.should_receive(:find).once.and_return(@report)
    end
    it "loads a report as @report from params[:id]" do
      get :download, :id => @report.id, :start_year => 2010, :start_month => 04
      assigns[:report].should == @report
    end
    context ":format => :csv" do
      before(:each) do
        @report.stub({
          :export_filename => "Q1 - 2010 TA Activity Report",
          :to_csv => nil,
          :csv => "one,two,three\nfour,five,six\n"
        })
      end
      it "sends the report as csv" do
        @report.should_receive(:to_csv)
        @report.should_receive(:csv).and_return("one,two,three\nfour,five,six\n")
        controller.should_receive(:send_data).with("one,two,three\nfour,five,six\n", {
          :type => "text/csv",
          :disposition => "attachment",
          :filename => "Q1 - 2010 TA Activity Report.csv"
        })
        get :download, :id => @report.id, :start_month => "1", :start_year => "2010", :end_month => '6', :end_year => '2010', :format => :csv
        flash[:notice].should be_nil
      end
    end
    
    context ":format => :pdf" do
      before(:each) do
        @report.stub(:export_filename).and_return("Q1 - 2010 TA Activity Report")
        @act1 = mock_model(Activity)
        @converter = mock(PDFConverter, {
          :html_to_pdf => "pdf"
        })
        PDFConverter.stub(:new).and_return(@converter)
      end
      context "report contains activities" do
        before(:each) do
          @report.stub(:activities).and_return([@act1])
        end
        it "updates image paths to full paths" do
          get :download, :id => @report.id, :start_month => "1", :start_year => "2010", :end_month => "6", :end_year => "2010", :format => :pdf
          assigns[:ytd_summary_map_path].should =~ /^#{Rails.root}/
          assigns[:summary_map_path].should =~ /^#{Rails.root}/
          assigns[:logo_path].should =~ /^#{Rails.root}/
        end
        it "sends the reports as pdf" do
          @converter.should_receive(:html_to_pdf).and_return("pdf")
          controller.should_receive(:send_data).with("pdf", {
            :type => "application/pdf",
            :disposition => "attachment",
            :filename => "#{@report.export_filename}.pdf"
          })
          get :download, :id => @report.id, :start_month => "1", :start_year => "2010", :end_month => "6", :end_year => "2010", :format => :pdf
          flash[:notice].should be_nil
        end
      end
    end
    
  end
end
