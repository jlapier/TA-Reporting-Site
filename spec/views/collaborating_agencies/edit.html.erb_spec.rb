require 'spec_helper'

describe "/collaborating_agencies/edit" do
  before(:each) do
    render 'collaborating_agencies/edit'
  end

  #Delete this example and add some real ones or delete this file
  it "should tell you where to find the file" do
    response.should have_tag('p', %r[Find me in app/views/collaborating_agencies/edit])
  end
end
