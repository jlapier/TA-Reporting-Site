require 'spec_helper'

describe ActivitiesHelper do
  before(:each) do
    State.stub(:abbreviated_from){ mock('Relation', {
      :[] => [mock_model(State, {:abbreviation => 'OR'}), mock_model(State, {:abbreviation => 'WA'})],
      :count => 2,
      :map => ['OR', 'WA']
    }) }
    @activities = [
      mock_model(Activity, {:id => 1}),
      mock_model(Activity, {:id => 2})
    ]
  end
  
  it "returns a sentence-ized list of state abbreviations where given activities occurred" do
    helper.abbreviated_states_from(@activities)[:sentence].should eq 'OR and WA'
  end
  it "returns a count of states where given activities occurred" do
    helper.abbreviated_states_from(@activities)[:count].should eq 2
  end
end
