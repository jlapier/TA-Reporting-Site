class ReportBreakdownsController < ApplicationController
  
  before_filter :require_user
  before_filter :load_essentials
  
  private
    def load_essentials
      load_report
      new_report_breakdown
    end
    def load_report
      @report = Report.find params[:report_id]
    end
    def new_report_breakdown
      @new_report_breakdown = ReportBreakdown.new(params[:report_breakdown].merge({
        :report => @report
      }))
    end
  protected
  public
  
    def create
      @saved = @new_report_breakdown.save
      respond_to do |format|
        format.js
        #format.html todo
      end
    end
end
