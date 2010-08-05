class SummaryReportsController < ApplicationController
  # GET /summary_reports
  # GET /summary_reports.xml
  def index
    @summary_reports = SummaryReport.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @summary_reports }
    end
  end

  # GET /summary_reports/1
  # GET /summary_reports/1.xml
  def show
    @summary_report = SummaryReport.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @summary_report }
    end
  end

  # GET /summary_reports/new
  # GET /summary_reports/new.xml
  def new
    @summary_report = SummaryReport.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @summary_report }
    end
  end

  # GET /summary_reports/1/edit
  def edit
    @summary_report = SummaryReport.find(params[:id])
  end

  # POST /summary_reports
  # POST /summary_reports.xml
  def create
    @summary_report = SummaryReport.new(params[:summary_report])

    respond_to do |format|
      if @summary_report.save
        format.html { redirect_to(@summary_report, :notice => 'SummaryReport was successfully created.') }
        format.xml  { render :xml => @summary_report, :status => :created, :location => @summary_report }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @summary_report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /summary_reports/1
  # PUT /summary_reports/1.xml
  def update
    @summary_report = SummaryReport.find(params[:id])

    respond_to do |format|
      if @summary_report.update_attributes(params[:summary_report])
        format.html { redirect_to(@summary_report, :notice => 'SummaryReport was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @summary_report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /summary_reports/1
  # DELETE /summary_reports/1.xml
  def destroy
    @summary_report = SummaryReport.find(params[:id])
    @summary_report.destroy

    respond_to do |format|
      format.html { redirect_to(summary_reports_url) }
      format.xml  { head :ok }
    end
  end
end
