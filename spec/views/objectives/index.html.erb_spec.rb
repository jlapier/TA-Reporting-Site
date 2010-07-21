require 'spec_helper'

describe "/objectives/index.html.erb" do
  include ObjectivesHelper

  before(:each) do
    assigns[:objectives] = [
      stub_model(Objective),
      stub_model(Objective)
    ]
  end

  it "renders a list of objectives" do
    render
  end
end
