require 'spec_helper'

describe ReportsController do
  
  let(:report){ mock_model(Report) }
  let(:summary_report){ mock_model(SummaryReport) }
  let(:objective){ mock_model(Objective) }
  let(:intensity_level){ mock_model(IntensityLevel) }
  let(:grant_activity){ mock_model(GrantActivity) }
  let(:activity){ mock_model(Activity) }
  
  before(:each) do
    controller.stub(:require_user){ true }
  end

  describe ":index" do
    before(:each) do
      Report.stub(:options).with(:include => :report_breakdowns){ [report] }
      SummaryReport.stub(:all){ [summary_report] }
      Objective.stub(:options).with(:order => 'number'){ [objective] }
    end
    it "loads all reports as @reports" do
      get :index
      assigns(:reports).should eq [report]
    end
    it "loads all summary reports as @summary_reports" do
      get :index
      assigns(:summary_reports).should eq [summary_report]
    end
    it "loads all objectives as @objectives" do
      get :index
      assigns(:objectives).should eq [objective]
    end
    it "renders the index template" do
      get :index
      response.should render_template("index")
    end
  end
  
  describe ":new" do
    let(:report){ mock_model(Report).as_new_record }
    before(:each) do
      Report.stub(:new){ report }
    end
    it "instantiates a new report as @report" do
      get :new
      assigns[:report].should eq report
    end
    it "renders the new template" do
      get :new
      response.should render_template("new")
    end
  end
  
  describe ":show, :id => integer, :summary_report_id => optional:integer" do
    let(:params) do
      {:id => 1, :summary_report_id => 1}
    end
    let(:report) do
      mock_model(Report, {
        :dates= => nil,
        :start_period => Date.new(2010, 1),
        :end_period => Date.new(2010, 6)
      })
    end
    let(:summary_report) do
      mock_model(SummaryReport, {
        :start_period => Date.new(2010, 5, 1),
        :end_period => Date.new(2010, 5, 30)
      })
    end
    context "report is found" do
      before(:each) do
        Report.stub(:find).once.and_return(report)
      end
      it "loads a report as @report from params[:id]" do
        get :show, params
        assigns(:report).should eq report
      end
      it "renders the show template" do
        get :show, params
        response.should render_template("show")
      end
    end
    context "report is not found" do
      before(:each) do
        Report.stub(:find).once.and_raise(ActiveRecord::RecordNotFound)
      end
      it "sets a flash[:notice]" do
        get :show, params
        flash[:notice].should_not be_nil
      end
      it "redirects to the reports page" do
        get :show, params
        response.should redirect_to reports_path
      end
    end
    context "summary report is found" do
      before(:each) do
        Report.should_receive(:find).once.and_return(report)
        SummaryReport.should_receive(:find).once.and_return(summary_report)
        IntensityLevel.should_receive(:all).and_return([intensity_level])
        GrantActivity.should_receive(:all).and_return([grant_activity])
      end
      it "loads a summary report from params[:summary_report_id]" do
        get :show, params
        assigns(:summary_report).should eq summary_report
      end
      it "updates report periods from summary report periods" do
        report.should_receive(:dates=).with({
          :start_year => 2010,
          :start_month => 5,
          :end_year => 2010,
          :end_month => 5
        })
        get :show, params
      end
      it "loads all IntensityLevels" do
        get :show, params
        assigns(:intensity_levels).should eq [intensity_level]
      end
      it "loads all GrantActivities" do
        get :show, params
        assigns(:grant_activities).should eq [grant_activity]
      end
    end
    context "summary report is not found or is not requested" do
      before(:each) do
        Report.should_receive(:find).once{ report }
        SummaryReport.should_receive(:find).once.and_raise(ActiveRecord::RecordNotFound)
        stub_flash_sweeper
      end
      it "is not found so sets flash.now[:notice]" do
        get :show, params
        flash[:notice].should_not be_nil
      end
      it "is not requested so sets a flash.now[:notice]" do
        get :show, params
        flash[:notice].should_not be_nil
      end
    end
  end
  
  describe ":edit, :id => integer" do
    before(:each) do
      Report.stub(:find){ report }
      Objective.should_receive(:all){ [objective] }
    end
    it "loads a report as @report from params[:id]" do
      get :edit, :id => 1
      assigns(:report).should eq report
    end
    it "loads all objectives as @objectives" do
      get :edit, :id => 1
      assigns(:objectives).should eq [objective]
    end
    it "renders the edit template" do
      get :edit, :id => 1
      response.should render_template("edit")
    end
  end
  
  describe ":create, :report => {}" do
    let(:params) do
      {:report => {:name => 'Q1 - 2010'}}
    end
    before(:each) do
      report.stub(:save){ nil }
      Report.should_receive(:new).with(params[:report].stringify_keys){ report }
    end
    it "instantiates a new report as @report from params[:report]" do
      post :create, params
      assigns(:report).should eq report
    end
    it "saves the new report" do
      report.should_receive(:save)
      post :create, params
    end
    context "save succeeds :)" do
      before(:each) do
        report.stub(:save){ true }
      end
      it "sets a flash[:notice]" do
        post :create, params
        flash[:notice].should_not be_nil
      end
      it "redirects to update the new report" do
        post :create, params
        response.should redirect_to edit_report_path(report.id)
      end
    end
    context "save fails :(" do
      before(:each) do
        report.stub(:save){ false }
      end
      it "renders the new template" do
        post :create, params
        response.should render_template("new")
      end
    end
  end
  
  describe ":update, :id => integer, :report => {}" do
    let(:params) do
      {:id => report.id, :report => {:name => 'New name'}}
    end
    before(:each) do
      report.stub(:update_attributes){ nil }
      Report.should_receive(:find){ report }
    end
    it "loads a report as @report from params[:id]" do
      put :update, params
      assigns(:report).should eq report
    end
    it "updates @report" do
      report.should_receive(:update_attributes).with(params[:report].stringify_keys)
      put :update, params
    end
    context "update succeeds :)" do
      before(:each) do
        report.stub(:update_attributes){ true }
      end
      it "sets flash[:notice]" do
        put :update, params
        flash[:notice].should_not be_nil
      end
      it "redirects to the reports page" do
        put :update, params
        response.should redirect_to reports_path
      end
    end
    context "update fails :(" do
      before(:each) do
        report.stub(:update_attributes){ false }
      end
      it "renders the edit template" do
        put :update, params
        response.should render_template("edit")
      end
    end
  end
  
  describe ":destroy, :id => integer" do
    let(:params) do
      {:id => report.id}
    end
    before(:each) do
      report.stub(:name){ 'doomed report' }
      Report.should_receive(:destroy).with(report.id){ report }
    end
    it "destroys the report of params[:id]" do
      delete :destroy, params
    end
    it "sets a flash[:notice]" do
      delete :destroy, params
      flash[:notice].should_not be_nil
    end
    it "redirects to the reports page" do
      delete :destroy, params
      response.should redirect_to reports_path
    end
  end
  
  describe ":download, :start_month => MM, start_year => YYYY, :end_month => MM, :end_year => YYYY" do
    let(:params) do
      {
        :id => report.id,
        :start_month => "1",
        :start_year => "2010",
        :end_month => '6',
        :end_year => '2010',
        :format => :csv
      }
    end
    let(:csv){ "one,two,three\nfour,five,six\n" }
    
    before(:each) do
      controller.stub(:render)
      report.stub(:dates=){ nil }
      report.stub(:export){ nil }
      report.stub(:name){ 'Q1 - 2010' }
      report.stub(:csv){ nil }
      report.stub(:activities){ [] }
      report.stub(:start_period){ Date.new(2010, 1) }
      report.stub(:end_period){ Date.new(2010, 6) }
      report.stub(:export_filename){ "Q1 - 2010 TA Activity Report" }
      report.stub(:to_csv){ nil }
      report.stub(:csv){ csv }
      summary_report.stub(:start_period){ Date.new(2010, 1) }
      summary_report.stub(:end_period){ Date.new(2010, 6) }
      
      SummaryReport.stub(:find){ summary_report }
      Report.should_receive(:find).once{ report }
    end
    it "loads a report as @report from params[:id]" do
      get :download, params
      assigns(:report).should eq report
    end
    context ":format => :csv" do
      it "sends the report as csv" do
        report.should_receive(:to_csv)
        controller.should_receive(:send_data).with(csv, {
          :type => "text/csv",
          :disposition => "attachment",
          :filename => "#{report.export_filename}.csv"
        })
        get :download, params
        flash[:notice].should be_nil
      end
    end
    
    context ":format => :pdf" do
      let(:converter) do
        mock(PDFConverter, {
          :html_to_pdf => "pdf"
        })
      end
      before(:each) do
        PDFConverter.stub(:new){ converter }
      end
      context "report contains activities" do
        before(:each) do
          params.merge!({:format => :pdf})
          report.stub(:activities){ [activity] }
        end
        it "updates image paths to full paths" do
          get :download, params
          assigns(:ytd_summary_map_path).should =~ /^#{Rails.root}/
          assigns(:summary_map_path).should =~ /^#{Rails.root}/
          assigns(:logo_path).should =~ /^#{Rails.root}/
        end
        it "sends the reports as pdf" do
          converter.should_receive(:html_to_pdf).and_return("pdf")
          controller.should_receive(:send_data).with("pdf", {
            :type => "application/pdf",
            :disposition => "attachment",
            :filename => "#{report.export_filename}.pdf"
          })
          get :download, params
          flash[:notice].should be_nil
        end
      end
    end
    
  end
end
