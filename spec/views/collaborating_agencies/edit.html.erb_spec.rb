require 'spec_helper'

describe "/collaborating_agencies/edit" do
  before(:each) do
    assigns[:collaborating_agency] = mock_model(CollaboratingAgency, {
      :name => 'Collaborating Agency',
      :abbrev => 'CA',
      :errors => mock('Errors', {:[] => {:name => '', :abbrev => ''}})
    })
    render 'collaborating_agencies/edit'
  end

  #Delete this example and add some real ones or delete this file
  it "should tell you where to find the file" do
    response.should have_tag('h1', %r[Update Collaborating Agency])
  end
end
