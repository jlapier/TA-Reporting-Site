require 'spec_helper'

describe TaCategory do
  before(:each) do
    @valid_attributes = {
      :name => "something TA"
    }
  end

  it "has a collection of activities" do
    ta = TaCategory.new
    ta.respond_to?(:activities).should be_true
    ta.activities.respond_to?(:build).should be_true
  end
  it "be valid given valid attributes" do
    ta = TaCategory.new(@valid_attributes)
    ta.should be_valid
  end
end
