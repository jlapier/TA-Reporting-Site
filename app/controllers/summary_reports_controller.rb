class SummaryReportsController < ApplicationController
  
  before_filter :require_user
  before_filter :get_summary_report, :only => [:show, :edit, :update, :destroy, :summary_map, :ytd_map]

  private
    def get_summary_report
      @summary_report = SummaryReport.find(params[:id])
    end
  protected

  public
    def index
      redirect_to reports_path
    end

    def show
      @intensity_levels = IntensityLevel.all
      @activity_types = ActivityType.all
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
          il = Magick::ImageList.new
          il.from_blob(render(:action => :map))
          sizedil = il.resize_to_fit(315,300)
          sizedil.format = "PNG"
          send_data(sizedil.to_blob, :filename => "map_for_period.png")
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
          il = Magick::ImageList.new
          il.from_blob(render(:action => :map))
          sizedil = il.resize_to_fit(315,300)
          sizedil.format = "PNG"
          send_data(sizedil.to_blob, :filename => "map_for_ytd.png")
        end
      end
    end
end
