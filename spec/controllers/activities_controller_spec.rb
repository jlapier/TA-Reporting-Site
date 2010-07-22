require 'spec_helper'

describe ActivitiesController do
  
  describe ":new" do
    
    before(:each) do
      @activity = mock_model(Activity).as_new_record
      Activity.stub(:new).and_return(@activity)
    end
    
    it "instantiates a new Activity as @activity" do
      Activity.should_receive(:new).and_return(@activity)
      get :new
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
      @objective = mock_model(Objective, {
        :name => 'Knowledge development'
      })
      
      Activity.stub(:new).and_return(@activity)
      Objective.stub(:find_or_create_by_name).and_return(@objective)
      
      @date_of_activity = Time.now + 2.days
      @stringy_params = {
        'date_of_activity' => @date_of_activity,
        'objective' => @objective,
        'activity_type' => 'Info request',
        'level_of_intensity' => 'General/Universal',
        'description' => 'activity went like this...',
        'states' => ['OR','WA','CA']
      }
      @params = {
        :date_of_activity => @date_of_activity,
        :objective => 'Knowledge development',
        :activity_type => 'Info request',
        :level_of_intensity => 'General/Universal',
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
        response.should redirect_to(new_activity_path)
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
  
  describe "auto_complete_for_activity_objective" do
    before(:each) do
      @objectives = [mock_model(Objective, {
        :[] => {'name' => 'Knowledge development'}
      })]
      Objective.stub(:find).and_return(@objectives)
    end
    
    it "collects all objectives w/ a name LIKE what is posted" do
      Objective.should_receive(:find).with(:all, {
        :conditions => [ 'LOWER(name) LIKE ?',
          '%' + 'know' + '%']
      })
      post :auto_complete_for_activity_objective, :activity => {:objective => 'Know'}
    end
    
    it "renders an inline response" do
      post :auto_complete_for_activity_objective, :activity => {:objective => 'Know'}
      response.body.should =~ /Knowledge development/
    end
  end
  
end