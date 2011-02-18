require 'spec_helper'

describe "/criteria/edit.html.erb" do
  include CriteriaHelper

  before(:each) do
    assign(:criterium, @criterium = stub_model(Criterium, :new_record? => false))
  end

  it "renders the edit criterium form" do
    render

    rendered.should have_selector("form[action='#{criterium_path(@criterium)}'][method=post]")
  end
end
