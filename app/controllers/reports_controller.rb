class ReportsController < ApplicationController

  before_filter :require_user
  
  private
    def send_report
      @report.export
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
      @reports = Report.options(:include => :report_breakdowns)
      @objectives = Objective.options(:order => 'number')
    end
    def new
      @report = Report.new
    end
    def show
      @report = Report.find(params[:id], :include => :report_breakdowns)
      @report.dates = params
    end
    def edit
      @report = Report.find(params[:id])
      @new_report_breakdown = ReportBreakdown.new
      @objectives = Objective.all
    end
    def update
      @report = Report.find(params[:id])
      if @report.update_attributes(params[:report])
        flash[:notice] = "Report successfully updated."
        redirect_to reports_path
      else
        render :edit
      end
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
    def destroy
      report = Report.destroy(params[:id])
      flash[:notice] = "Deleted the report: #{report.name}"
      redirect_to reports_path
    end
    def download
      @report = Report.find(params[:id])
      @report.dates = params
      send_report
    end
end
