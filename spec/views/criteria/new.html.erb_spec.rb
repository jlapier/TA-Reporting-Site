require 'spec_helper'

describe "/criteria/new.html.erb" do
  include CriteriaHelper

  before(:each) do
    assign(:criterium, Criterium.new)
  end

  it "renders new criterium form" do
    render

    rendered.should have_selector("form[action='#{criteria_path}'][method=post]")
  end
end
