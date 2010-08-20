require 'spec_helper'

describe CriteriaController do

  before(:each) do
    controller.stub(:require_user).and_return(true)
    @post_params = {
      :kind => "Objective",
      :number => 2,
      :name => "Test Objective",
      :description => "develop practical, efficient, cost-effective, and sustainable strategies for collecting and using data to improve secondary transition and post-secondary outcomes."
    }
  end

  def mock_criterium(stubs={})
    @mock_criterium ||= mock_model(Criterium, stubs)
  end

  describe "GET index" do
    it "assigns all criteria as @criteria" do
      Criterium.stub(:find).with(:all, :order => 'number').and_return([mock_criterium])
      get :index
      assigns[:criteria].should == [mock_criterium]
    end
  end

  describe "GET show" do
    it "assigns the requested criterium as @criterium" do
      Criterium.stub(:find).with("37").and_return(mock_criterium)
      get :show, :id => "37"
      assigns[:criterium].should equal(mock_criterium)
    end
  end

  describe "GET new" do
    it "assigns a new criterium as @criterium" do
      Criterium.stub(:new).and_return(mock_criterium)
      get :new
      assigns[:criterium].should equal(mock_criterium)
    end
  end

  describe "GET edit" do
    it "assigns the requested criterium as @criterium" do
      Criterium.stub(:find).with("37").and_return(mock_criterium)
      get :edit, :id => "37"
      assigns[:criterium].should equal(mock_criterium)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created criterium as @criterium" do
        Criterium.stub(:new).with({'these' => 'params'}).and_return(mock_criterium(:save => true))
        post :create, :criterium => {:these => 'params'}
        assigns[:criterium].should equal(mock_criterium)
      end

      it "redirects to the criterium list" do
        Criterium.stub(:new).and_return(mock_criterium(:save => true))
        post :create, :criterium => {}
        response.should redirect_to(criteria_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved criterium as @criterium" do
        Criterium.stub(:new).with({'these' => 'params'}).and_return(mock_criterium(:save => false))
        post :create, :criterium => {:these => 'params'}
        assigns[:criterium].should equal(mock_criterium)
      end

      it "re-renders the 'new' template" do
        Criterium.stub(:new).and_return(mock_criterium(:save => false))
        post :create, :criterium => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested criterium" do
        Criterium.should_receive(:find).with("37").and_return(mock_criterium)
        mock_criterium.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :criterium => {:these => 'params'}
      end

      it "assigns the requested criterium as @criterium" do
        Criterium.stub(:find).and_return(mock_criterium(:update_attributes => true))
        put :update, :id => "1"
        assigns[:criterium].should equal(mock_criterium)
      end

      it "redirects to the criterium list" do
        Criterium.stub(:find).and_return(mock_criterium(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(criteria_url)
      end
    end

    describe "with invalid params" do
      it "updates the requested criterium" do
        Criterium.should_receive(:find).with("37").and_return(mock_criterium)
        mock_criterium.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :criterium => {:these => 'params'}
      end

      it "assigns the criterium as @criterium" do
        Criterium.stub(:find).and_return(mock_criterium(:update_attributes => false))
        put :update, :id => "1"
        assigns[:criterium].should equal(mock_criterium)
      end

      it "re-renders the 'edit' template" do
        Criterium.stub(:find).and_return(mock_criterium(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested criterium" do
      Criterium.should_receive(:find).with("37").and_return(mock_criterium)
      mock_criterium.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the criteria list" do
      Criterium.stub(:find).and_return(mock_criterium(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(criteria_url)
    end
  end

end
