class SummaryReportsController < ApplicationController
  
  before_filter :require_user
  before_filter :get_summary_report, :only => [:show, :evaluation, :edit, :update, :destroy, :summary_map, :ytd_map]
  
  caches_page :summary_map, :ytd_map

  private
    def get_summary_report
      @summary_report = SummaryReport.find(params[:id])
      @summary_map_path = summary_map_summary_report_path(@summary_report, :format => :png)
      @ytd_summary_map_path = ytd_map_summary_report_path(@summary_report, :format => :png)
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
  protected

  public
    def index
      redirect_to reports_path
    end

    def show
      @intensity_levels = IntensityLevel.all
      @grant_activities = GrantActivity.all
    end

    def evaluation
      @ta_delivery_methods = TaDeliveryMethod.all
      @intensity_levels = IntensityLevel.all
      @ta_categories = TaCategory.all
    end

    def new
      @summary_report = SummaryReport.new
    end

    def edit
    end

    def create
      @summary_report = SummaryReport.new(params[:summary_report])

      if @summary_report.save
        redirect_to(summary_reports_path, :notice => 'Summary Report was successfully created.') 
      else
        render :action => "new" 
      end
    end

    def update
      if @summary_report.update_attributes(params[:summary_report])
        redirect_to(summary_reports_path, :notice => 'Summary Report was successfully updated.')
      else
        render :action => "edit"
      end
    end

    def destroy
      @summary_report.destroy

      redirect_to(summary_reports_url) 
    end

    def summary_map
      @intensity_levels = IntensityLevel.find :all, :order => "number"
      @states = {}
      @intensity_levels.each do |il|
        @states[il.id] = @summary_report.states_by_type_for_period :intensity_level => il
      end
      
      respond_to do |format|
        format.svg { render :action => :map }
        format.png do
          svgxml = render_to_string('summary_reports/map')
          il = Magick::ImageList.new
          il.from_blob(svgxml)
          sizedil = il.resize_to_fit(315,300)
          cache_map(svgxml, summary_map_summary_report_path(@summary_report, :format => :svg))
          sizedil.format = "PNG"
          send_data(sizedil.to_blob, :filename => "summary_map.png") and return
        end
      end
    end

    def ytd_map
      @intensity_levels = IntensityLevel.find :all, :order => "number"
      @states = {}
      @intensity_levels.each do |il|
        @states[il.id] = @summary_report.states_by_type_for_ytd :intensity_level => il
      end
      
      respond_to do |format|
        format.svg { render :action => :map }
        format.png do
          svgxml = render_to_string('summary_reports/map')
          il = Magick::ImageList.new
          il.from_blob(svgxml)
          sizedil = il.resize_to_fit(315,300)
          cache_map(svgxml, ytd_map_summary_report_path(@summary_report, :format => :svg))
          sizedil.format = "PNG"
          send_data(sizedil.to_blob, :filename => "ytd_map.png") and return
        end
      end
    end
end
