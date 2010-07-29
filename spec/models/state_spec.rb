require 'spec_helper'

describe State do
  before(:each) do
    @valid_attributes = {
      :name => "Jefferson",
      :abbreviation => "JE"
    }
  end

  it "should create a new instance given valid attributes" do
    State.create!(@valid_attributes)
  end
  
  describe "custom finders in named scopes" do
    before(:each) do
      State.delete_all
      @a_region = State.create!(:name => "a region", :abbreviation => "AR")
      @a_state = State.create!(:name => "a state", :abbreviation => "AS", :region_id => @a_region.id)
    end
  
    it "should find just states" do
      states = State.just_states
      states.size.should == 1
      states.should == [@a_state]
    end

    it "should find just regions" do
      regions = State.regions
      regions.size.should == 1
      regions.should == [@a_region]
    end
  end
end

