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
      @summary_report.dates = params
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
      @summary_report.dates = params
      @intensity_levels = IntensityLevel.find :all, :order => "number DESC"
      @states = {}
      @intensity_levels.each do |il|
        @states[il.id] = @summary_report.states_by_type_for_period :intensity_level => il
      end
      send_data(render(:action => :map), :filename => "map_for_period.svg")
    end

    def ytd_map
      @summary_report.dates = params
      @intensity_levels = IntensityLevel.find :all, :order => "number DESC"
      @states = {}
      @intensity_levels.each do |il|
        @states[il.id] = @summary_report.states_by_type_for_ytd :intensity_level => il
      end
      send_data(render(:action => :map), :filename => "map_for_ytd.svg")
    end
end
