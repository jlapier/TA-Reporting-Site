class ReportsController < ApplicationController

  before_filter :require_user
  before_filter :load_summary_report, :only => [:show, :download]
  
  private
    def send_report
      case !params[:format].blank? && params[:format].to_sym || 'nil'
      when :csv
        send_csv_report
      when :pdf
        send_pdf_report
      else
        flash[:notice] = "Only CSV and PDF downloads are available."
        redirect_to reports_path and return
      end
    end
    def send_pdf_report
      unless @report.activities.empty?
        @ytd_summary_map_path = File.join(Rails.root, "public", ytd_map_summary_report_path(@summary_report, :format => :png))
        @summary_map_path = File.join(Rails.root, "public", summary_map_summary_report_path(@summary_report, :format => :png))
        converter = PDFConverter.new()
        html = @template.capture{ render :partial => 'shared/pdf_output.html.erb' }
        #file = File.new("temp.html", "w+")
        #file << html
        #file.close
        #pdfkit = PDFKit.new(html)
        #pdfkit.stylesheets << File.join(Rails.root, "public/stylesheets/pdf_basic.css")
        send_data(converter.html_to_pdf(html), :type => "application/pdf", :disposition => "attachment", :filename => "#{@report.export_filename}.pdf")
        #pdfkit = PDFKit.new("http://localhost:3001/reports/13?summary_report_id=2", :username => "first.user@example.com", :password => "first.user.password")
        #pdfkit.to_file(File.join(Rails.root, 'public', "#{@report.export_filename}.pdf"))
        # pdfkit.to_file(File.join(Rails.root, 'public', "report.pdf"))
        #pdf = File.open(File.join(Rails.root, 'public', "#{@report.export_filename}.pdf"))
        #send_data(pdfkit.to_pdf, :type => "application/pdf", :disposition => "attachment", :filename => "#{@report.export_filename}.pdf")
      else
        flash[:notice] = "No activity has been recorded to satisfy the reporting period."
        redirect_to reports_path and return
      end
    end
    def send_csv_report
      @report.to_csv
      unless @report.csv.nil?
        send_data(@report.csv, :type => "text/csv", :disposition => "attachment", :filename => "#{@report.export_filename}.csv")
      else
        flash[:notice] = "No activity has been recorded to satisfy the reporting period."
        redirect_to reports_path and return
      end
    end
    def load_summary_report
      begin
        @report = Report.find(params[:id], :include => :report_breakdowns)
      rescue ActiveRecord::RecordNotFound
        flash[:notice] = "That report could not be found."
        redirect_to reports_path
      end
      begin
        @summary_report = SummaryReport.find(params[:summary_report_id])
        @summary_map_path = summary_map_summary_report_path(@summary_report, :format => :png)
        @ytd_summary_map_path = ytd_map_summary_report_path(@summary_report, :format => :png)
        @report.dates = {
          :start_year => @summary_report.start_period.year,
          :start_month => @summary_report.start_period.month,
          :end_year => @summary_report.end_period.year,
          :end_month => @summary_report.end_period.month
        }
        @intensity_levels = IntensityLevel.all
        @activity_types = ActivityType.all
      rescue ActiveRecord::RecordNotFound
        if params[:summary_report_id]
          flash.now[:notice] = "The requested summary report could not be found."
        else
          flash.now[:notice] = "No summary report was selected - previewing standard report only with default start - end periods: #{@report.start_period.strftime("%b, %Y")} - #{@report.end_period.strftime("%b, %Y")}"
        end
      end
    end
  protected
  public
    def index
      @reports = Report.options(:include => :report_breakdowns)
      @summary_reports = SummaryReport.all
      @objectives = Objective.options(:order => 'number')
    end
    def new
      @report = Report.new
    end
    def show
      @download_params = {}
      @download_params = {:summary_report_id => params[:summary_report_id]} if @summary_report
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
      send_report
    end
end
