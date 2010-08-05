require 'spec_helper'

describe Criterium do
  before(:each) do
    @valid_attributes = {
      :number => 1,
      :name => "Knowledge Development"
    }
    @criterium = Criterium.new
  end
  
  %w(reports activities).each do |col|
    it "has a collection of #{col}" do
      @criterium.respond_to?(col.to_sym).should be_true
      @criterium.send(col.to_sym).respond_to?(:build).should be_true
    end
  end
  it "has a collection of activities" do
    ta = TaCategory.new
    ta.respond_to?(:activities).should be_true
    ta.activities.respond_to?(:build).should be_true
  end
  it "should create a new instance given valid attributes" do
    Criterium.create!(@valid_attributes)
  end
  it "is not valid without a name" do
    ta = Criterium.new
    ta.should be_invalid
    ta.errors.on(:name).include?("can't be blank").should be_true
  end
end
