require 'spec_helper'

describe StatesController do

  describe ":index" do
    before(:each) do
      state = mock_model(State)
      @states = [state]
      State.stub(:regions).and_return(@states)
    end
    it "loads all regions as @states" do
      state = mock_model(State)
      @states = [state]
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

end
