require 'spec_helper'

describe Objective do
  before(:each) do
    @valid_attributes = {
      :number => 1,
      :name => "Knowledge Development"
    }
  end

  it "should create a new instance given valid attributes" do
    Objective.create!(@valid_attributes)
  end
end
