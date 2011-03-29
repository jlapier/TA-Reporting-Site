require 'spec_helper'

describe ActivitiesController do
  
  let(:activity_search){ mock(ActivitySearch) }
  let(:activity){ stub_model(Activity) }

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
        'ta_delivery_method_id' => 2,
        'intensity_level_id' => 3,
        'description' => 'activity went like this...',
        'states' => ['OR','WA','CA']
      }
      @params = {
        :date_of_activity => @date_of_activity,
        :objective_id => 1,
        :ta_delivery_method_id => 2,
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
        response.should render_template('activities/new')
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
      Activity.should_receive(:find).with(1).and_return(@activity)
      put :update, :id => 1
      assigns[:activity].should eql @activity
    end
    it "updates @activity" do
      @activity.should_receive(:update_attributes).with({
        'date_of_activity' => Date.new(2010, 01),
        'objective_id' => 1,
        'ta_delivery_method_id' => 2,
        'intensity_level_id' => 3,
        'description' => 'of activity'
      })
      put :update, :id => 1, :activity => {
        :date_of_activity => Date.new(2010, 01),
        :objective_id => 1,
        :ta_delivery_method_id => 2,
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
        it "renders the edit template" do
          put :update, :id => 1
          response.should render_template "activities/edit"
        end
      end
    end
  end
  
  describe ":download, :format => :csv, :activity_search => {} (optional)" do
    let(:params) do
      {
        :format => :csv
      }
    end
    let(:search_params) do
      {
        :activity_search => {
          :objective_id => 42,
          :keywords => 'blah boogity'
        }
      }.merge!(params)
    end
    before(:each) do
      activity_search.stub(:name){ 'Search Name' }
      controller.stub(:render)
    end
    context "with :activity_search params" do
      before(:each) do
        activity_search.stub(:activities){ [activity] }
        ActivitySearch.should_receive(:new).with(search_params[:activity_search].stringify_keys){ activity_search }
      end
      it "loads relevant activities" do
        get :download, search_params
        assigns(:activities).should eq [activity]
      end
      it "sends the CSV export as a file download" do
        controller.should_receive(:send_data).
        with("Date,Objective,TA Delivery Method,Grant Activities,Intensity,"+
          "TA Categories,Description of Activity,Agencies,States\n,,,,,,,,\n",
          :type => "text/csv", :disposition => "attachment",
          :filename => "Search Name.csv")
        get :download, search_params
      end
    end
    context "without :activity_search params" do
      before(:each) do
        request.env["HTTP_REFERER"] = activities_path
        ActivitySearch.should_receive(:new).with({}){ mock(ActivitySearch, {
          :name => 'Search Name',
          :activities => [activity]
        }) }
      end
      it "loads all activities" do
        get :download, params
        assigns(:activities).should eq [activity]
      end
      it "sends the CSV export as a file download" do
        controller.should_receive(:send_data).
        with("Date,Objective,TA Delivery Method,Grant Activities,Intensity,"+
          "TA Categories,Description of Activity,Agencies,States\n,,,,,,,,\n",
          :type => "text/csv", :disposition => "attachment",
          :filename => "Search Name.csv")
        get :download, params
      end
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
  
  describe ":update_grant_activites, :objective_id => required, :id => optional" do
    before(:each) do
      @grant_activity_one = mock_model(GrantActivity, {
        :objective_ids => [1,2]
      })
      @grant_activity_two = mock_model(GrantActivity, {
        :objective_ids => [3,4]
      })
      @grant_activities = [@grant_activity_one, @grant_activity_two]
      GrantActivity.stub(:all).with(:include => :objectives).and_return(@grant_activities)
    end
    it "loads grant activities eager loading objectives" do
      GrantActivity.should_receive(:all).with(:include => :objectives).and_return(@grant_activities)
      xhr :get, :update_grant_activities, :objective_id => "1"
    end
    it "selects grant activities associated w/ :objective_id" do
      xhr :get, :update_grant_activities, :objective_id => "1"
      assigns[:grant_activities].should eql [@grant_activity_one]
    end
    it "instantiates a new Activity as @activity" do
      activity = mock_model(Activity)
      Activity.should_receive(:new).and_return(activity)
      xhr :get, :update_grant_activities, :objective_id => "1"
      assigns[:activity].should eql activity
    end
    it "renders the update_grant_activities.js.rjs template" do
      xhr :get, :update_grant_activities, :objective_id => "1"
      response.should render_template("activities/update_grant_activities")
    end
    it "without :id, instantiates a new Activity as @activity" do
      activity = mock_model(Activity).as_new_record
      Activity.should_receive(:new).and_return(activity)
      xhr :get, :update_grant_activities
      assigns[:activity].should eql activity
    end
    it "with :id, loads Activity as @activity" do
      activity = mock_model(Activity)
      Activity.should_receive(:find).with("1").and_return(activity)
      xhr :get, :update_grant_activities, :id => "1"
      assigns[:activity].should eql activity
    end
  end
  
end
