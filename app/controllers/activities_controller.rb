class ActivitiesController < ApplicationController
  
  before_filter :require_user
  before_filter :get_form_options, :only => [ :new, :edit ]
  
  private
    def get_form_options
      @activity = Activity.new
      @criteria = Criterium.all
      @regions = State.regions.options(:include => :states)
    end
  protected
  public
    def index
      # TODO: check for search or filter
      @activities = Activity.all
    end
  
    def new
    end
  
    def create
      @activity = Activity.new(params[:activity])
      if @activity.save
        flash[:notice] = "New Activity successfully saved."
        redirect_to(activities_path)
      else
        render :new
      end
    end
  
    def edit
      @activity = Activity.find params[:id]
    end
  
    def update
      @activity = Activity.find params[:id]
      if @activity.update_attributes(params[:activity])
        flash[:notice] = "Activity updated."
        redirect_to activities_path
      else
        render :edit
      end
    end
end
