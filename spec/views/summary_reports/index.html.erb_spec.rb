require 'spec_helper'

describe "/summary_reports/index.html.erb" do
  include SummaryReportsHelper

  before(:each) do
    assign(:summary_reports, [
      stub_model(SummaryReport,
        :name => "value for name",
        :report_title_format => "value for report_title_format"
      ),
      stub_model(SummaryReport,
        :name => "value for name",
        :report_title_format => "value for report_title_format"
      )
    ])
  end

  it "renders a list of summary_reports" do
    render
    rendered.should have_selector("tr>td", :content => "value for name")
    rendered.should have_selector("tr>td", :content => "value for report_title_format")
  end
end
