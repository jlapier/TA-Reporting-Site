require 'spec_helper'

describe "/objectives/new.html.erb" do
  include ObjectivesHelper

  before(:each) do
    assigns[:objective] = stub_model(Objective,
      :new_record? => true
    )
  end

  it "renders new objective form" do
    render

    response.should have_tag("form[action=?][method=post]", objectives_path) do
    end
  end
end
