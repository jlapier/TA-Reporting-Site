require 'spec_helper'

describe "/criteria/edit.html.erb" do
  include CriteriaHelper

  before(:each) do
    assigns[:criterium] = @criterium = stub_model(Criterium,
      :new_record? => false
    )
  end

  it "renders the edit criterium form" do
    render

    response.should have_tag("form[action=#{criterium_path(@criterium)}][method=post]") do
    end
  end
end
