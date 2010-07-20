class ActivitiesController < ApplicationController
  
  before_filter :find_or_create_named_objective, :only => [:create, :update]

  auto_complete_for :objective, :name
  
  private
    def find_or_create_named_objective
      if params[:activity] && params[:activity][:objective]
        params[:activity][:objective] = Objective.find_or_create_by_name(params[:activity][:objective])
      end
    end
  protected
  public
    def auto_complete_for_activity_objective
      @objectives = Objective.find(:all,
        :conditions => [ 'LOWER(name) LIKE ?',
          '%' + params[:activity][:objective].downcase + '%' ]
      )
      render :inline => "<%= auto_complete_result(@objectives, 'name') %>"
    end
    
    def index
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
        render :new
      end
    end
  
    def edit
    end
  
    def update
    end
end