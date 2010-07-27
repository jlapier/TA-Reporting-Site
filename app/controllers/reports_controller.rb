class ReportsController < ApplicationController

  before_filter :require_user
  
  def index
    @activity_count = Activity.count
    @new_report = Report.new
  end
  def new
    @report = Report.new
  end
  def create
    @report = Report.new(params[:report])
    if @report.month.nil?
      flash[:notice] = "Please select a month and year to export."
      redirect_to reports_path and return
    end
    @report.export_as_csv
    unless @report.csv.nil?
      send_data(@report.csv, :type => "text/csv", :disposition => "attachment", :filename => "#{@report.month.to_formatted_s(:year_month_number)} WRRC TA Activity Report.csv")
    else
      flash[:notice] = "No activity has been recorded for #{@report.month.to_formatted_s(:month_year_string)}"
      redirect_to reports_path and return
    end
  end
end
