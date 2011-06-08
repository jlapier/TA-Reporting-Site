class ActivitiesController < ApplicationController
  
  include ActivitySearchController
  
  before_filter :require_user
  before_filter :load_states, :only => [ :new, :edit ]
  respond_to :csv, :only => :download
  
  private
    def load_states
      @states = State.just_states
    end
    def load_criteria
      @objectives = Objective.all
      @ta_delivery_methods = TaDeliveryMethod.all
      @intensity_levels = IntensityLevel.all
      @grant_activities = GrantActivity.all
      @states = State.order('name').all
      @ta_categories = TaCategory.all
      @collaborating_agencies = CollaboratingAgency.all
    end
    def load_grant_activities(objective_id='')
      @grant_activities = []
      unless objective_id.blank?
        # @grant_activities = GrantActivity.with_objectives(ga.objective_ids)
        all_grant_activities = GrantActivity.all :include => :objectives
        @grant_activities = all_grant_activities.select do |ga|
          ga.objective_ids.include?(objective_id.to_i)
        end
      end
    end
  protected
  public
    # moving in from SummaryReportsController
    def evaluate
      load_activities
      @ta_delivery_methods = TaDeliveryMethod.all
      @intensity_levels = IntensityLevel.all
      @ta_categories = TaCategory.all
    end
    
    # download csv
    def download
      load_activities
      filename = @search.name
      send_csv_file_of(filename, @activities) and return
    end
    
    def update_grant_activities
      load_grant_activities(params[:objective_id])
      begin
        @activity = Activity.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        @activity = Activity.new
      end
    end
    
    def index
      load_criteria
      load_activities
    end
  
    def new
      @activity = Activity.new
      load_grant_activities
    end
  
    def create
      @activity = Activity.new(params[:activity])
      if @activity.save
        flash[:notice] = "New Activity successfully saved."
        redirect_to(activities_path)
      else
        load_states
        render :new
      end
    end
    
    def show
      @activity = Activity.find params[:id]
      redirect_to edit_activity_path @activity
    end

    def edit
      @activity = Activity.find params[:id]
      load_grant_activities(@activity.objective_id)
    end
  
    def update
      @activity = Activity.find params[:id]
      respond_to do |format|
        if @activity.update_attributes(params[:activity])
          flash[:notice] = "Activity updated."
          format.html{redirect_to activities_path}
        else
          load_states
          format.html{render :edit}
        end
      end
    end
    
    def destroy
      Activity.destroy(params[:id])
      flash[:notice] = "Activity deleted."
      redirect_to activities_path
    end
end
