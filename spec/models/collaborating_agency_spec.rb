require 'spec_helper'

describe CollaboratingAgency do
  before(:each) do
    @valid_attributes = {
      :name => "Super Cool Center",
      :abbrev => "SCC"
    }
  end

  it "should create a new instance given valid attributes" do
    CollaboratingAgency.create!(@valid_attributes)
  end
end
