require 'spec_helper'

describe StatesController do
  
  before(:each) do
    controller.stub(:require_user).and_return(true)
  end

  describe ":index" do
    before(:each) do
      state = mock_model(State)
      @states = [state]
      State.stub(:regions).and_return(@states)
    end
    it "loads all regions as @states" do
      State.should_receive(:regions).and_return(@states)
      get :index
      assigns[:states].should == @states
    end
    
    it "renders the index template" do
      get :index
      response.should render_template('states/index')
    end
  end
  
  describe ":new" do
    before(:each) do
      @state = mock_model(State).as_new_record
      State.stub(:new).and_return(@state)
    end
    it "instantiates a new State as @state" do
      State.should_receive(:new).and_return(@state)
      get :new
      assigns[:state].should == @state
    end
    it "renders the new template" do
      get :new
      response.should render_template('states/new')
    end
  end
  
  describe ":edit, :id => integer" do
    before(:each) do
      @state = mock_model(State)
      State.stub(:find).and_return(@state)
    end
    it "loads a state as @state" do
      State.should_receive(:find).and_return(@state)
      get :edit, :id => 1
      assigns[:state].should == @state
    end
    it "renders the edit template" do
      get :edit, :id => 1
      response.should render_template('states/edit')
    end
  end
  
  describe ":update, :id => integer, :state => {}" do
    before(:each) do
      @state = mock_model(State, {
        :update_attributes => nil
      })
      State.stub(:find).and_return(@state)
    end
    it "loads a state as @state" do
      State.should_receive(:find).and_return(@state)
      put :update, :id => 1
      assigns[:state].should == @state
    end
    it "updates @state from params[:state]" do
      @state.should_receive(:update_attributes).with({
        'name' => 'Delware',
        'region_id' => 1
      })
      put :update, :id => 1, :state => {:name => 'Delware', :region_id => 1}
    end
    context "update succeeds :)" do
      before(:each) do
        @state.stub(:update_attributes).and_return(true)
      end
      it "sets a flash[:notice]" do
        put :update, :id => 1
        flash[:notice].should_not be_nil
      end
      it "redirects to the states page" do
        put :update, :id => 1
        response.should redirect_to states_path
      end
    end
    context "update fails :(" do
      before(:each) do
        @state.stub(:update_attributes).and_return(false)
      end
      it "renderes the edit template" do
        put :update, :id => 1
        response.should render_template('states/edit')
      end
    end
  end
  
  describe ":create, :state => {}" do
    before(:each) do
      @state = mock_model(State, {
        :save => nil
      }).as_new_record
      State.stub(:new).and_return(@state)
    end
    it "instantiates a new state as @state" do
      State.should_receive(:new).and_return(@state)
      post :create
      assigns[:state].should == @state
    end
    it "saves the new @state" do
      @state.should_receive(:save)
      post :create
    end
    context "save succeeds" do
      before(:each) do
        @state.stub(:save).and_return(true)
      end
      it "sets a flash[:notice]" do
        post :create
        flash[:notice].should_not be_nil
      end
      it "redirects to the states page" do
        post :create
        response.should redirect_to states_path
      end
    end
    context "save fails :(" do
      before(:each) do
        @state.stub(:save).and_return(false)
      end
      it "renders the new template" do
        post :create
        response.should render_template('states/new')
      end
    end
  end
  
  describe ":destroy, :id(s) => integer or [int1,int2]" do
    before(:each) do
      @state = mock_model(State, {
        :name => 'Idaho'
      })
      State.stub(:destroy).and_return(@state)
    end
    it "destroys the state(s) with the given id(s)" do
      State.should_receive(:destroy).with(1)
      delete :destroy, :id => 1
    end
    it "sets a flash[:notice]" do
      delete :destroy, :id => 1
      flash[:notice].should_not be_nil
    end
    it "redirects to the states page" do
      delete :destroy, :id => 1
      response.should redirect_to states_path
    end
  end

end
