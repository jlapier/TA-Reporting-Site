require 'spec_helper'

describe "/summary_reports/show.html.erb" do
  include SummaryReportsHelper
  before(:each) do
    assigns[:summary_report] = @summary_report = mock_model(SummaryReport).as_null_object
    assigns[:intensity_levels] = []
  end

  it "renders attributes in <p>" do
    render
  end
end
