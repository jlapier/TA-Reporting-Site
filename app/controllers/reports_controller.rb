class ReportsController < ApplicationController

  before_filter :require_user
  before_filter :new_report, :only => [:index, :edit]
  
  private
    def new_report
      @new_report = Report.new
    end
    def send_export
      @report.csv_export
      unless @report.csv.nil?
        send_data(@report.csv, :type => "text/csv", :disposition => "attachment", :filename => @report.export_filename)
      else
        flash[:notice] = "No activity has been recorded to satisfy the reporting selections."
        redirect_to reports_path and return
      end
    end
  protected
  public
    def index
      @activity_count = Activity.count
    end
    def new
      @report = Report.new
    end
    def edit
      @report = Report.find(params[:id])
      @new_report_breakdown = ReportBreakdown.new
      @objectives = Objective.all
    end
    def create
      @report = Report.new(params[:report])
      if @report.save
        flash[:notice] = "New Report successfully created."
        redirect_to edit_report_path(@report)
      else
        render :new
      end
    end
    def export
      @report = Report.find(params[:id])
      if params[:report][:period]
        @report.period = params[:report][:period]
      elsif params[:report][:start_period] && params[:report][:end_period]
        @report.start_period = params[:report][:start_period]
        @report.end_period = params[:report][:end_period]
      end
      send_export
    end
end
