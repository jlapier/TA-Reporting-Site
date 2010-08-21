require 'spec_helper'

describe ActivitiesController do

  before(:each) do
    controller.stub(:require_user).and_return(true)
  end
  
  describe ":new" do
    
    before(:each) do
      @activity = mock_model(Activity).as_new_record
      Activity.stub(:new).and_return(@activity)
    end
    
    it "instantiates a new Activity as @activity" do
      Activity.should_receive(:new).and_return(@activity)
      get :new
    end
    
    it "loads states as @states" do
      state = mock_model(State)
      State.should_receive(:just_states).and_return([state])
      get :new
      assigns[:states].should eql [state]
    end
    
    it "loads criteria as @criteria" do
      criterium = mock_model(Criterium)
      Criterium.should_receive(:all).and_return([criterium])
      get :new
      assigns[:criteria].should eql [criterium]
    end
    
    it "renders the new template" do
      get :new
      response.should render_template('activities/new')
    end
  end
  
  describe ":create, :activity => {}" do
    before(:each) do
      @activity = mock_model(Activity, {
        :save => nil
      }).as_new_record
      @criterium = mock_model(Criterium, {
        :type => 'Objective',
        :number => 1,
        :name => 'Knowledge development'
      })
      
      Activity.stub(:new).and_return(@activity)
      Criterium.stub(:find_or_create_by_name).and_return(@criterium)
      
      @date_of_activity = Time.now + 2.days
      @stringy_params = {
        'date_of_activity' => @date_of_activity,
        'objective_id' => 1,
        'activity_type_id' => 2,
        'intensity_level_id' => 3,
        'description' => 'activity went like this...',
        'states' => ['OR','WA','CA']
      }
      @params = {
        :date_of_activity => @date_of_activity,
        :objective_id => 1,
        :activity_type_id => 2,
        :intensity_level_id => 3,
        :description => 'activity went like this...',
        :states => ['OR','WA','CA']
      }
    end
    
    it "instantiates a new Activity as @activity w/ params[:activity]" do
      Activity.should_receive(:new).with(@stringy_params).and_return(@activity)
      post :create, :activity => @params
      assigns[:activity].should == @activity
    end
    
    it "saves the new @activity" do
      @activity.should_receive(:save)
      post :create
    end
    
    context "save succeeds :)" do
      before(:each) do
        @activity.stub(:save).and_return(true)
      end
      
      it "sets a flash[:notice]" do
        post :create
        flash[:notice].should_not be_nil
      end
      
      it "redirects to the new activity page" do
        post :create
        response.should redirect_to(activities_path)
      end
    end
    
    context "save fails :(" do
      before(:each) do
        @activity.stub(:save).and_return(false)
      end
      
      it "renders the new template" do
        post :create
        response.should render_template('activities/new.html.erb')
      end
    end
  end
  
  describe ":update, :id => integer, :activity => {}" do
    before(:each) do
      @activity = mock_model(Activity, {
        :update_attributes => nil
      })
      Activity.stub(:find).and_return(@activity)
    end
    it "loads an activity as @activity from params[:id]" do
      Activity.should_receive(:find).with('1').and_return(@activity)
      put :update, :id => 1
      assigns[:activity].should eql @activity
    end
    it "updates @activity" do
      @activity.should_receive(:update_attributes).with({
        'date_of_activity' => Date.new(2010, 01),
        'objective_id' => 1,
        'activity_type_id' => 2,
        'intensity_level_id' => 3,
        'description' => 'of activity'
      })
      put :update, :id => 1, :activity => {
        :date_of_activity => Date.new(2010, 01),
        :objective_id => 1,
        :activity_type_id => 2,
        :intensity_level_id => 3,
        :description => 'of activity'
      }
    end
    context "standard http request" do
      context "update succeeds :)" do
        before(:each) do
          @activity.stub(:update_attributes).and_return(true)
        end
        it "sets a flash[:notice]" do
          put :update, :id => 1
          flash[:notice].should_not be_nil
        end
        it "redirects to the activities page" do
          put :update, :id => 1
          response.should redirect_to activities_path
        end
      end
      context "update fails :(" do
        before(:each) do
          @activity.stub(:update_attributes).and_return(false)
        end

        it "loads states as @states" do
          state = mock_model(State)
          State.should_receive(:just_states).and_return([state])
          get :new
          assigns[:states].should eql [state]
        end

        it "loads criteria as @criteria" do
          criterium = mock_model(Criterium)
          Criterium.should_receive(:all).and_return([criterium])
          get :new
          assigns[:criteria].should eql [criterium]
        end
        it "renders the edit template" do
          put :update, :id => 1
          response.should render_template "activities/edit"
        end
      end
    end
    context "xml http request" do
      context "update succeeds :)" do
        before(:each) do
          @activity.stub(:update_attributes).and_return(true)
        end
        it "does not set flash[:notice]" do
          xhr :put, :update, :id => 1
          flash[:notice].should be_nil
        end
        it "loads all objectives as @objectives" do
          objective = mock_model(Objective)
          Objective.stub(:all).and_return([objective])
          xhr :put, :update, :id => 1
          assigns[:objectives].should eql [objective]
        end
        it "loads all activity types as @activity_types" do
          activity_type = mock_model(ActivityType)
          ActivityType.stub(:all).and_return([activity_type])
          xhr :put, :update, :id => 1
          assigns[:activity_types].should eql [activity_type]
        end
        it "loads all intensity levels as @intensity_levels" do
          intensity_level = mock_model(IntensityLevel)
          IntensityLevel.stub(:all).and_return([intensity_level])
          xhr :put, :update, :id => 1
          assigns[:intensity_levels].should eql [intensity_level]
        end
        it "renders the update.js template" do
          xhr :put, :update, :id => 1
          response.should render_template "activities/update"
        end
      end
      context "update fails :(" do
        before(:each) do
          @activity.stub(:update_attributes).and_return(false)
        end
        it "loads all objectives as @objectives" do
          objective = mock_model(Objective)
          Objective.stub(:all).and_return([objective])
          xhr :put, :update, :id => 1
          assigns[:objectives].should eql [objective]
        end
        it "loads all activity types as @activity_types" do
          activity_type = mock_model(ActivityType)
          ActivityType.stub(:all).and_return([activity_type])
          xhr :put, :update, :id => 1
          assigns[:activity_types].should eql [activity_type]
        end
        it "loads all intensity levels as @intensity_levels" do
          intensity_level = mock_model(IntensityLevel)
          IntensityLevel.stub(:all).and_return([intensity_level])
          xhr :put, :update, :id => 1
          assigns[:intensity_levels].should eql [intensity_level]
        end
        it "renders the update.js template" do
          xhr :put, :update, :id => 1
          response.should render_template "activities/update"
        end
      end
    end
  end
  
  describe ":edit_all" do
    it "loads all activities as @activities" do
      activity = mock_model(Activity)
      Activity.stub(:all).and_return([activity])
      get :edit_all
      assigns[:activities].should eql([activity])
    end
    it "loads all objectives as @objectives" do
      objective = mock_model(Objective)
      Objective.stub(:all).and_return([objective])
      get :edit_all
      assigns[:objectives].should eql [objective]
    end
    it "loads all activity types as @activity_types" do
      activity_type = mock_model(ActivityType)
      ActivityType.stub(:all).and_return([activity_type])
      get :edit_all
      assigns[:activity_types].should eql [activity_type]
    end
    it "loads all intensity levels as @intensity_levels" do
      intensity_level = mock_model(IntensityLevel)
      IntensityLevel.stub(:all).and_return([intensity_level])
      get :edit_all
      assigns[:intensity_levels].should eql [intensity_level]
    end
    it "renders the edit_all template" do
      get :edit_all
      response.should render_template("activities/edit_all")
    end
  end
  
  describe ":destroy, :id => integer" do
    before(:each) do
      Activity.stub(:destroy)
    end
    it "destroys the activity of params[:id]" do
      Activity.should_receive(:destroy)
      delete :destroy, :id => 1
    end
    it "sets a flash[:notice]" do
      delete :destroy, :id => 1
      flash[:notice].should_not be_nil
    end
    it "redirects to the activities page" do
      delete :destroy, :id => 1
      response.should redirect_to activities_path
    end
  end
  
end
