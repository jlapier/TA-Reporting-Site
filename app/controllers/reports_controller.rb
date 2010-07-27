class ReportsController < ApplicationController

  before_filter :require_user
  
  def index
    @activities = Activity.all
    @report = FasterCSV.dump(@activities)
  end
  def new
    @report = Report.new
  end
end
