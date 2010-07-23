class ReportsController < ApplicationController

  before_filter :require_user
  
  def index
    @activities = Activity.all
    @report = @activities.to_csv(:except => [:created_at, :updated_at])
  end
  def new
    @report = Report.new
  end
end
