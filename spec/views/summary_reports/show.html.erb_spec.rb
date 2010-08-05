require 'spec_helper'

describe "/summary_reports/show.html.erb" do
  include SummaryReportsHelper
  before(:each) do
    assigns[:summary_report] = @summary_report = stub_model(SummaryReport,
      :name => "value for name",
      :report_title_format => "value for report_title_format"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ name/)
    response.should have_text(/value\ for\ report_title_format/)
  end
end
