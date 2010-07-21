require 'spec_helper'

describe "/objectives/edit.html.erb" do
  include ObjectivesHelper

  before(:each) do
    assigns[:objective] = @objective = stub_model(Objective,
      :new_record? => false
    )
  end

  it "renders the edit objective form" do
    render

    response.should have_tag("form[action=#{objective_path(@objective)}][method=post]") do
    end
  end
end
