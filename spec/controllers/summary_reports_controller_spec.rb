require 'spec_helper'

describe SummaryReportsController do

  before(:each) do
    controller.stub(:require_user).and_return(true)
  end

  def mock_summary_report(stubs={})
    @mock_summary_report ||= mock_model(SummaryReport, stubs)
  end

  describe "GET index" do
    it "redirects to the other reports controller" do
      get :index
      response.should redirect_to(reports_path)
    end
  end

  describe "GET show" do
    it "assigns the requested summary_report as @summary_report" do
      SummaryReport.stub(:find).with("37").and_return(mock_summary_report)
      mock_summary_report.stub(:dates=).and_return(nil)
      get :show, :id => "37"
      assigns[:summary_report].should equal(mock_summary_report)
    end
  end

  describe "GET new" do
    it "assigns a new summary_report as @summary_report" do
      SummaryReport.stub(:new).and_return(mock_summary_report)
      get :new
      assigns[:summary_report].should equal(mock_summary_report)
    end
  end

  describe "GET edit" do
    it "assigns the requested summary_report as @summary_report" do
      SummaryReport.stub(:find).with("37").and_return(mock_summary_report)
      get :edit, :id => "37"
      assigns[:summary_report].should equal(mock_summary_report)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created summary_report as @summary_report" do
        SummaryReport.stub(:new).with({'these' => 'params'}).and_return(mock_summary_report(:save => true))
        post :create, :summary_report => {:these => 'params'}
        assigns[:summary_report].should equal(mock_summary_report)
      end

      it "redirects to the created summary_report" do
        SummaryReport.stub(:new).and_return(mock_summary_report(:save => true))
        post :create, :summary_report => {}
        response.should redirect_to(summary_reports_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved summary_report as @summary_report" do
        SummaryReport.stub(:new).with({'these' => 'params'}).and_return(mock_summary_report(:save => false))
        post :create, :summary_report => {:these => 'params'}
        assigns[:summary_report].should equal(mock_summary_report)
      end

      it "re-renders the 'new' template" do
        SummaryReport.stub(:new).and_return(mock_summary_report(:save => false))
        post :create, :summary_report => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested summary_report" do
        SummaryReport.should_receive(:find).with("37").and_return(mock_summary_report)
        mock_summary_report.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :summary_report => {:these => 'params'}
      end

      it "assigns the requested summary_report as @summary_report" do
        SummaryReport.stub(:find).and_return(mock_summary_report(:update_attributes => true))
        put :update, :id => "1"
        assigns[:summary_report].should equal(mock_summary_report)
      end

      it "redirects to the summary_report" do
        SummaryReport.stub(:find).and_return(mock_summary_report(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(summary_reports_url)
      end
    end

    describe "with invalid params" do
      it "updates the requested summary_report" do
        SummaryReport.should_receive(:find).with("37").and_return(mock_summary_report)
        mock_summary_report.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :summary_report => {:these => 'params'}
      end

      it "assigns the summary_report as @summary_report" do
        SummaryReport.stub(:find).and_return(mock_summary_report(:update_attributes => false))
        put :update, :id => "1"
        assigns[:summary_report].should equal(mock_summary_report)
      end

      it "re-renders the 'edit' template" do
        SummaryReport.stub(:find).and_return(mock_summary_report(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested summary_report" do
      SummaryReport.should_receive(:find).with("37").and_return(mock_summary_report)
      mock_summary_report.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the summary_reports list" do
      SummaryReport.stub(:find).and_return(mock_summary_report(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(summary_reports_url)
    end
  end

end
