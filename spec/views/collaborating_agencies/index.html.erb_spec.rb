require 'spec_helper'

describe "/collaborating_agencies/index" do
  before(:each) do
    render 
  end

  it "should have a header" do
    rendered.should have_selector('h1', :content => "Collaborating Agencies")
  end
end
