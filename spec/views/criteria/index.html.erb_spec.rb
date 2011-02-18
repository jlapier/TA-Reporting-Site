require 'spec_helper'

describe "/criteria/index.html.erb" do
  include CriteriaHelper

  before(:each) do
    assign(:criteria, [
      stub_model(Criterium),
      stub_model(Criterium)
    ])
  end

  it "renders a list of criteria" do
    render
  end
end
