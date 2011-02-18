require 'spec_helper'

describe "/collaborating_agencies/new" do
  before(:each) do
    assign(:collaborating_agency, CollaboratingAgency.new)
    
    render
  end

  it "should have a header tag" do
    rendered.should have_selector('h1', :content => "New Collaborating Agency")
  end
end
