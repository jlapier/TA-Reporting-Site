require 'spec_helper'

describe CriteriaController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/criteria" }.should route_to(:controller => "criteria", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/criteria/new" }.should route_to(:controller => "criteria", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/criteria/1" }.should route_to(:controller => "criteria", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/criteria/1/edit" }.should route_to(:controller => "criteria", :action => "edit", :id => "1")
      { :get => "/criteria/62/edit" }.should route_to(:controller => "criteria", :action => "edit", :id => "62")
    end

    it "recognizes and generates #create" do
      { :post => "/criteria" }.should route_to(:controller => "criteria", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/criteria/1" }.should route_to(:controller => "criteria", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/criteria/1" }.should route_to(:controller => "criteria", :action => "destroy", :id => "1") 
    end
  end
end
