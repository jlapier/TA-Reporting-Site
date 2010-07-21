class ObjectivesController < ApplicationController
  private
  protected
  public
    def index
      @objectives = Objective.find :all, :order => 'number'
    end

    def show
      @objective = Objective.find(params[:id])
    end

    def new
      @objective = Objective.new
    end

    def edit
      @objective = Objective.find(params[:id])
    end

    def create
      @objective = Objective.new(params[:objective])

      if @objective.save
        redirect_to(objectives_url, :notice => 'Objective created.')
      else
        render :action => "new"
      end
    end

    def update
      @objective = Objective.find(params[:id])

      if @objective.update_attributes(params[:objective])
        redirect_to(objectives_url, :notice => 'Objective updated.')
      else
        render :action => "edit"
      end
    end

    def destroy
      @objective = Objective.find(params[:id])
      @objective.destroy

      redirect_to(objectives_url)
    end
end
