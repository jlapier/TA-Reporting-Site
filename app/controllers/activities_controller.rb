class ActivitiesController < ApplicationController
  
  before_filter :require_user
  before_filter :get_form_options, :only => [ :new, :edit ]
  
  private
    def get_form_options
      @criteria = Criterium.all
      @states = State.just_states
    end
    def load_criteria
      @objectives = Objective.all
      @activity_types = ActivityType.all
      @intensity_levels = IntensityLevel.all
    end
  protected
  public
    def index
      # TODO: check for search or filter
      @activities = Activity.all
    end
  
    def new
      @activity = Activity.new
    end
  
    def create
      @activity = Activity.new(params[:activity])
      if @activity.save
        flash[:notice] = "New Activity successfully saved."
        redirect_to(activities_path)
      else
        get_form_options
        render :new
      end
    end
    
    def edit_all
      @activities = Activity.all
      load_criteria
    end
    
    def edit
      @activity = Activity.find params[:id]
    end
  
    def update
      @activity = Activity.find params[:id]
      respond_to do |format|
        if @activity.update_attributes(params[:activity])
          unless request.xhr?
            flash[:notice] = "Activity updated."
          else
            load_criteria
          end
          format.html{redirect_to activities_path}
          format.js
        else
          if request.xhr?
            load_criteria
          else
            get_form_options
          end
          format.html{render :edit}
          format.js
        end
      end
    end
end
