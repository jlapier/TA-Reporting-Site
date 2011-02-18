require 'spec_helper'

describe "/collaborating_agencies/edit" do
  before(:each) do
    assign(:collaborating_agency, mock_model(CollaboratingAgency, {
      :name => 'Collaborating Agency',
      :abbrev => 'CA',
      :errors => mock('Errors', {:[] => {:name => '', :abbrev => ''}})
    }))
    render
  end

  it "should have a header tag" do
    rendered.should have_selector('h1', :content => "Update Collaborating Agency")
  end
end
