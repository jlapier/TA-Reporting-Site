class StatesController < ApplicationController

  before_filter :require_user
  
  def index
    @states = State.regions
  end
  
  def new
    @state = State.new
    @regions = State.regions
  end
  
  def edit
    @state = State.find(params[:id])
    @regions = State.regions
  end
  
  def update
    @state = State.find(params[:id])
    if @state.update_attributes(params[:state])
      flash[:notice] = "State successfully updated."
      redirect_to states_path
    else
      flash[:warning] = "Please correct any errors and try again."
      render :edit
    end
  end
  
  def create
    @state = State.new(params[:state])
    if @state.save
      flash[:notice] = "State created successfully."
      redirect_to states_path
    else
      flash[:warning] = "PLease correct any errors and try again."
      render :new
    end
  end
  
  def destroy
    state = State.destroy(params[:id])
    flash[:notice] = "Deleted #{state.name}."
    redirect_to states_path
  end
end
