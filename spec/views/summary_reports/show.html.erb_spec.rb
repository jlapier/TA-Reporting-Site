require 'spec_helper'

describe "/summary_reports/show.html.erb" do
  include SummaryReportsHelper
  before(:each) do
    assigns[:summary_report] = @summary_report = stub_model(SummaryReport,
      :id => 2,
      :name => "some report name",
      :end_period => Date.new(2010, 5),
      :start_period => Date.new(2010,5),
      :start_ytd => Date.new(2010,1)
    )
    assigns[:intensity_levels] = @intensity_levels = [stub_model(IntensityLevel,
      :name => "Intense", :number => 1)]
  end

  it "renders attributes in <p>" do
    render
  end
end
