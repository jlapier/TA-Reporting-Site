require 'spec_helper'

describe "/summary_reports/new.html.erb" do
  include SummaryReportsHelper

  before(:each) do
    assigns[:summary_report] = stub_model(SummaryReport,
      :new_record? => true,
      :name => "value for name",
      :report_title_format => "value for report_title_format"
    )
  end

  it "renders new summary_report form" do
    render

    response.should have_tag("form[action=?][method=post]", summary_reports_path) do
      with_tag("input#summary_report_name[name=?]", "summary_report[name]")
      with_tag("input#summary_report_report_title_format[name=?]", "summary_report[report_title_format]")
    end
  end
end
