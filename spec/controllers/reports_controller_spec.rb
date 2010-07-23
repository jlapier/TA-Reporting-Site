require 'spec_helper'

describe ReportsController do

  before(:each) do
    controller.stub(:require_user).and_return(true)
  end

  #Delete this example and add some real ones
  it "should use ReportsController" do
    controller.should be_an_instance_of(ReportsController)
  end

end
