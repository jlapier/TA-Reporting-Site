require 'spec_helper'

describe "/criteria/new.html.erb" do
  include CriteriaHelper

  before(:each) do
    assigns[:criterium] = stub_model(Criterium,
      :new_record? => true
    )
  end

  it "renders new criterium form" do
    render

    response.should have_tag("form[action=?][method=post]", criteria_path) do
    end
  end
end
