require 'spec_helper'

describe SummaryReportsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/summary_reports" }.should route_to(:controller => "summary_reports", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/summary_reports/new" }.should route_to(:controller => "summary_reports", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/summary_reports/1" }.should route_to(:controller => "summary_reports", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/summary_reports/1/edit" }.should route_to(:controller => "summary_reports", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/summary_reports" }.should route_to(:controller => "summary_reports", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/summary_reports/1" }.should route_to(:controller => "summary_reports", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/summary_reports/1" }.should route_to(:controller => "summary_reports", :action => "destroy", :id => "1") 
    end
  end
end
