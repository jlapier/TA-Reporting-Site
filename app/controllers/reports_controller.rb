class ReportsController < ApplicationController

  include ActivitySearchController

  before_filter :require_user
  before_filter :load_activities, :only => [:ytd_map, :summary_map]
  respond_to :csv, :pdf, :only => :download
  
  private
    def load_report
      load_activities
      @summary_report = @search.summary_report
      @report = Report.includes(:report_breakdowns).find(params[:id])
      search_params = params[:activity_search].present? ? {:activity_search => params[:activity_search]} : {}
      @summary_map_path = summary_map_report_path(@report, {:format => :png}.merge!(search_params))
      @ytd_summary_map_path = ytd_map_report_path(@report, {:format => :png}.merge!(search_params))
      
      @report.dates = {
        :start_year => @summary_report.start_period.year,
        :start_month => @summary_report.start_period.month,
        :end_year => @summary_report.end_period.year,
        :end_month => @summary_report.end_period.month
      } if @report
    end
    def load_states
      if @search
        @states = State.from(@search.activities.map(&:id))
      end
    end
    def cache_map(map, path)
      full_path = File.join(Rails.root, "public", path)
      dir = File.dirname(full_path)
      logger.debug("dirname - #{dir}")
      FileUtils.mkdir_p(dir)
      file = File.new(full_path, "w+")
      file << map
      file.close
    end
    def send_report
      load_report
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
        @ytd_summary_map_path = File.join(Rails.root.to_s, "public", ytd_map_report_path(@summary_report, :format => :svg))
        @summary_map_path = File.join(Rails.root.to_s, "public", summary_map_report_path(@summary_report, :format => :svg))
        @logo_path = File.join(Rails.root.to_s, "public", "images", "logo.jpg")
        converter = PDFConverter.new()
        html = render_to_string(:partial => 'shared/pdf_output')
        send_data(converter.html_to_pdf(html), :type => "application/pdf", :disposition => "attachment", :filename => "#{@report.export_filename}.pdf") and return
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
  protected
  public
    def index
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
      # inactive see :index
      load_report
    end
    def summary
      # inactive see :index
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
      send_report and return
    end
    def summary_map
      @intensity_levels = IntensityLevel.find :all, :order => "number"
      @states = {}
      @intensity_levels.each do |il|
        @states[il.id] = State.from_activities(@search.activities.where(:intensity_level_id => il).all)
      end
      
      respond_to do |format|
        format.svg { render :action => :map }
        format.png do
          svgxml = render_to_string('reports/map')
          il = Magick::ImageList.new
          il.from_blob(svgxml)
          sizedil = il.resize_to_fit(315,300)
          cache_map(svgxml, summary_map_report_path(@report, :format => :svg))
          sizedil.format = "PNG"
          send_data(sizedil.to_blob, :filename => "summary_map.png") and return
        end
      end
    end

    def ytd_map
      @intensity_levels = IntensityLevel.find :all, :order => "number"
      @states = {}
      @intensity_levels.each do |il|
        @states[il.id] = State.from_activities(@search.ytd_activities.where(:intensity_level_id => il).all)
      end
      
      respond_to do |format|
        format.svg { render :action => :map }
        format.png do
          svgxml = render_to_string('reports/map')
          il = Magick::ImageList.new
          il.from_blob(svgxml)
          sizedil = il.resize_to_fit(315,300)
          cache_map(svgxml, ytd_map_report_path(@report, :format => :svg))
          sizedil.format = "PNG"
          send_data(sizedil.to_blob, :filename => "ytd_map.png") and return
        end
      end
    end
end
