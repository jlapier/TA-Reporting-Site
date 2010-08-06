require 'spec_helper'

describe "/summary_reports/show.html.erb" do
  include SummaryReportsHelper
  before(:each) do
    assigns[:summary_report] = @summary_report = stub_model(SummaryReport,
      :name => "some report name",
      :end_period => Date.new(2010, 5)
    )
  end

  it "renders attributes in <p>" do
    render
  end
end
