class ActivitiesController < ApplicationController
  
  private
  protected
  public
    def index
    end
  
    def new
      @activity = Activity.new
      @criteria = Criterium.all
      @regions = State.regions.options(:include => :states)
    end
  
    def create
      @activity = Activity.new(params[:activity])
      if @activity.save
        flash[:notice] = "New Activity successfully saved."
        redirect_to(new_activity_path)
      else
        render :new
      end
    end
  
    def edit
    end
  
    def update
    end
end