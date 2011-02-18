require 'spec_helper'

describe "/summary_reports/edit.html.erb" do
  include SummaryReportsHelper

  before(:each) do
    @summary_report = stub_model(SummaryReport,
      :new_record? => false,
      :name => "value for name",
      :report_title_format => "value for report_title_format"
    )
    assign(:summary_report, @summary_report)
  end

  it "renders the edit summary_report form" do
    render

    rendered.should have_selector("form[action='#{summary_report_path(@summary_report)}'][method=post]")
    rendered.should have_selector("input#summary_report_name[name='summary_report[name]']")
    rendered.should have_selector("input#summary_report_report_title_format[name='summary_report[report_title_format]']")
  end
end
