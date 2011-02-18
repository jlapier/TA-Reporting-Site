require 'spec_helper'

describe "/password_resets/new" do
  before(:each) do
    assign(:password_reset, PasswordReset.new)
  end
  
  it "renders" do
    render 
  end
end
