require 'spec_helper'

describe "/collaborating_agencies/new" do
  before(:each) do
    assigns[:collaborating_agency] = mock_model(CollaboratingAgency, {
      :name => '',
      :abbrev => '',
      :errors => mock('Errors', {:[] => {:name => '', :abbrev => ''}})
    }).as_new_record
    render 'collaborating_agencies/new'
  end

  #Delete this example and add some real ones or delete this file
  it "should tell you where to find the file" do
    response.should have_tag('h1', %r[New Collaborating Agency])
  end
end
