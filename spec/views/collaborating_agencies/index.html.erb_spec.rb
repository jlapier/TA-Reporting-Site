require 'spec_helper'

describe "/collaborating_agencies/index" do
  before(:each) do
    render 'collaborating_agencies/index'
  end

  #Delete this example and add some real ones or delete this file
  it "should tell you where to find the file" do
    response.should have_tag('p', %r[Find me in app/views/collaborating_agencies/index])
  end
end
