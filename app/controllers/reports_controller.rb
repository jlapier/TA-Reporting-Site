class ReportsController < ApplicationController

  include ActivitySearchController # <= :load_activities, :search_params
  include MapController # <= :load_states_for, :map_for

  before_filter :require_user
  respond_to :csv, :pdf, :only => :download
  caches_page :summary_map, :ytd_map
  
  private
    def load_report
      load_activities
      @summary_report = @search.summary_report
      @report = Report.includes(:report_breakdowns).find(params[:id])
      path_opts = {:format => :png}.merge!(search_params)
      @summary_map_path = summary_map_report_path(@report, path_opts)
      @ytd_summary_map_path = ytd_map_report_path(@report, path_opts)
      
      @report.dates = {
        :start_year => @summary_report.start_date.year,
        :start_month => @summary_report.start_date.month,
        :end_year => @summary_report.end_date.year,
        :end_month => @summary_report.end_date.month
      } if @report
    end
    
    def send_pdf_report
      unless @report.activities.empty?
        path_opts = {:format => :svg}.merge!(search_params)
        @ytd_summary_map_path = File.join(Rails.root.to_s, "public", ytd_map_report_path(@report, path_opts))
        @summary_map_path = File.join(Rails.root.to_s, "public", summary_map_report_path(@report, path_opts))
        @logo_path = File.join(Rails.root.to_s, "public", "images", "logo.jpg")
        converter = PDFConverter.new()
        html = render_to_string(:partial => 'shared/pdf_output')
        send_data(converter.html_to_pdf(html), {
          :type => "application/pdf",
          :disposition => "attachment",
          :filename => "#{@report.export_filename}.pdf"
        }) and return
      else
        flash[:notice] = "No activity has been recorded to satisfy the reporting period."
        redirect_to reports_path and return
      end
    end
    
    def send_csv_report
      @report.to_csv
      unless @report.csv.nil?
        send_data(@report.csv, {
          :type => "text/csv",
          :disposition => "attachment",
          :filename => "#{@report.export_filename}.csv"
        }) and return
      else
        flash[:notice] = "No activity has been recorded to satisfy the reporting period."
        redirect_to reports_path and return
      end
    end
  protected
  public
    def index
      # TODO: move this to :show
      if params[:id].present? and params[:view].present?
        case params[:view]
        when 'Full'
          load_report
          render :show and return
        when 'Summary'
          load_report
          render :summary and return
        else
          flash.now[:notice] = "Can't generate the requested view."
        end
      end
      unless @report
        @reports = Report.options(:include => :report_breakdowns)
        @objectives = Objective.options(:order => 'number')
      end
    end
    
    def new
      @report = Report.new
    end
    
    def show
      # not yet implemented see :index
      load_report
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
      # wonky catch-all to handle unknown formats
      unless [:csv, :pdf].include? request.format.to_sym
        flash[:notice] = "Only CSV and PDF downloads are available."
        redirect_to reports_path and return
      end
      load_report
      respond_to do |format|
        format.csv { send_csv_report and return }
        format.pdf { send_pdf_report and return }
      end
    end
    
    def summary_map
      load_activities
      load_states_for(:period)
      
      respond_to do |format|
        format.svg { render :action => :map }
        format.png { map_for(:period) }
      end
    end

    def ytd_map
      load_activities
      load_states_for(:ytd)
      
      respond_to do |format|
        format.svg { render :action => :map }
        format.png { map_for(:ytd) }
      end
    end
end
