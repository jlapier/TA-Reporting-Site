require 'spec_helper'

describe State do
  before(:each) do
    @valid_attributes = {
      :name => "Jefferson",
      :region_id => 1,
      :abbreviation => "JE"
    }
    @state = State.new
  end
  
  describe "states and regions" do  
    it "must have a name" do
      @state.should_not be_valid
      @state.errors[:name].include?("can't be blank").should be_true
    end
  
    it "have many activities" do
      @state.respond_to?(:activities).should be_true
      @state.activities.respond_to?(:build).should be_true
    end
  end
  
  describe "regions" do
    it "may or may not have an abbreviation" do
      @state.name = 'Some Region'
      @state.should be_valid
      @state.abbreviation = 'SR'
      @state.should be_valid
    end
    it "have many states" do
      @state.respond_to?(:states).should be_true
      @state.states.respond_to?(:build).should be_true
    end
  end
  
  describe "states" do
    before(:each) do
      @state = State.new({
        :name => 'Some State',
        :abbreviation => 'SS',
        :region_id => 1
      })
    end
    it "must have an abbreviation" do
      @state.abbreviation = nil
      @state.should_not be_valid
      @state.errors[:abbreviation].include?("can't be blank").should be_true
    end
    it "belongs to a region" do
      @state.respond_to?(:region_id).should be_true
      @state.respond_to?(:build_region).should be_true
    end
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

