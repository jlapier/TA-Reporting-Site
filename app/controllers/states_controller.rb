class StatesController < ApplicationController

  before_filter :require_user
  before_filter :get_regions

  private
    def get_regions
      @regions = State.regions
    end
  protected
  public
  def index
    @states = State.regions
  end
  
  def new
    @state = State.new
  end
  
  def edit
    @state = State.find(params[:id])
  end
  
  def update
    @state = State.find(params[:id])
    if @state.update_attributes(params[:state])
      flash[:notice] = "State successfully updated."
      redirect_to states_path
    else
      render :edit
    end
  end
  
  def create
    @state = State.new(params[:state])
    if @state.save
      flash[:notice] = "State created successfully."
      redirect_to states_path
    else
      render :new
    end
  end
  
  def destroy
    state = State.destroy(params[:id])
    flash[:notice] = "Deleted #{state.name}."
    redirect_to states_path
  end
end
