require 'spec_helper'

describe ObjectivesController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/objectives" }.should route_to(:controller => "objectives", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/objectives/new" }.should route_to(:controller => "objectives", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/objectives/1" }.should route_to(:controller => "objectives", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/objectives/1/edit" }.should route_to(:controller => "objectives", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/objectives" }.should route_to(:controller => "objectives", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/objectives/1" }.should route_to(:controller => "objectives", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/objectives/1" }.should route_to(:controller => "objectives", :action => "destroy", :id => "1") 
    end
  end
end
