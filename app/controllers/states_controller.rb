class StatesController < ApplicationController
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
end
