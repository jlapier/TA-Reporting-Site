require 'spec_helper'

describe "/summary_reports/new.html.erb" do
  include SummaryReportsHelper

  before(:each) do
    assign(:summary_report, SummaryReport.new)
  end

  it "renders new summary_report form" do
    render

    rendered.should have_selector("form[action='#{summary_reports_path}'][method=post]")
    rendered.should have_selector("input#summary_report_name[name='summary_report[name]']")
    rendered.should have_selector("input#summary_report_report_title_format[name='summary_report[report_title_format]']")
  end
end
