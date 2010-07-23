class CollaboratingAgenciesController < ApplicationController
  def index
    @collaborating_agencies = CollaboratingAgency.all
  end

  def new
    @collaborating_agency = CollaboratingAgency.new
  end

  def create
    @collaborating_agency = CollaboratingAgency.new(params[:collaborating_agency])
    if @collaborating_agency.save
      flash[:notice] = "New Collaborating Agency successfully saved."
      redirect_to collaborating_agencies_path
    else
      render :new
    end
  end

  def edit
    @collaborating_agency = CollaboratingAgency.find(params[:id])
  end

  def update
    @collaborating_agency = CollaboratingAgency.find(params[:id])
    if @collaborating_agency.update_attributes(params[:collaborating_agency])
      flash[:notice] = "Collaborating agency successfully updated."
      redirect_to collaborating_agencies_path
    else
      render :edit
    end
  end

  def destroy
    agency = CollaboratingAgency.destroy(params[:id])
    flash[:notice] = "Deleted #{agency.name}"
    redirect_to collaborating_agencies_path
  end

end
