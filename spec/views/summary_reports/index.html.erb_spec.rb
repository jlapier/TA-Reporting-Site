require 'spec_helper'

describe "/summary_reports/index.html.erb" do
  include SummaryReportsHelper

  before(:each) do
    assigns[:summary_reports] = [
      stub_model(SummaryReport,
        :name => "value for name",
        :report_title_format => "value for report_title_format"
      ),
      stub_model(SummaryReport,
        :name => "value for name",
        :report_title_format => "value for report_title_format"
      )
    ]
  end

  it "renders a list of summary_reports" do
    render
    response.should have_tag("tr>td", "value for name".to_s, 2)
    response.should have_tag("tr>td", "value for report_title_format".to_s, 2)
  end
end
