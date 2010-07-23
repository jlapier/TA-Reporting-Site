require 'spec_helper'

describe CollaboratingAgenciesController do

  #Delete these examples and add some real ones
  it "should use CollaboratingAgenciesController" do
    controller.should be_an_instance_of(CollaboratingAgenciesController)
  end


  describe ":index" do
    it "loads collaborating agencies as @collaborating_agencies" do
      agency = mock_model(CollaboratingAgency)
      CollaboratingAgency.should_receive(:all).and_return([agency])
      get :index
      assigns[:collaborating_agencies] = [agency]
    end
    
    it "renders the index template" do
      get :index
      response.should render_template('collaborating_agencies/index.html.erb')
    end
  end
  
  describe ":new" do
    it "instantiates a new collaborating agency as @collaborating_agency" do
      @agency = mock_model(CollaboratingAgency).as_new_record
      CollaboratingAgency.should_receive(:new).and_return(@agency)
      get :new
      assigns[:collaborating_agency].should == @agency
    end
    
    it "renders the new template" do
      get :new
      response.should render_template('collaborating_agencies/new.html.erb')
    end
  end
  
  describe ":create, :collaborating_agency => {}" do
    before(:each) do
      @params = {
        :name => 'Some Agency',
        :abbrev => 'SA'
      }
      @stringy_params = @params.stringify_keys
      @agency = mock_model(CollaboratingAgency, {
        :save => nil
      }).as_new_record
      CollaboratingAgency.stub(:new).and_return(@agency)
    end
    
    it "instantiates a new agency from params[:collaborating_agency]" do
      CollaboratingAgency.should_receive(:new).with(@stringy_params).and_return(@agency)
      post :create, :collaborating_agency => @params
      assigns[:collaborating_agency].should == @agency
    end
    it "saves the new agency" do
      @agency.should_receive(:save)
      post :create
    end
    
    context "save succeeds :)" do
      before(:each) do
        @agency.stub(:save).and_return(true)
      end
      it "sets a flash[:notice]" do
        post :create
        flash[:notice].should_not be_nil
      end
      it "redirects to the collaborating agencies page" do
        post :create
        response.should redirect_to collaborating_agencies_path
      end
    end
    context "save fails :(" do
      before(:each) do
        @agency.stub(:save).and_return(false)
      end
      it "renders the new template" do
        post :create
        response.should render_template("collaborating_agencies/new.html.erb")
      end
    end
  end
  
  describe ":edit, :id => integer" do
    before(:each) do
      @agency = mock_model(CollaboratingAgency)
      CollaboratingAgency.stub(:find).and_return(@agency)
    end
    it "loads a collaborating agency as @collaborating_agency" do
      @agency = mock_model(CollaboratingAgency)
      CollaboratingAgency.should_receive(:find).with("1").and_return(@agency)
      get :edit, :id => 1
      assigns[:collaborating_agency].should == @agency
    end
    it "renders the edit template" do
      get :edit, :id => 1
      response.should render_template("collaborating_agencies/edit.html.erb")
    end
  end
  
  describe ":update, :id => integer, :collaborating_agency => {}" do
    before(:each) do
      @agency = mock_model(CollaboratingAgency, {
        :update_attributes => nil
      })
      CollaboratingAgency.stub(:find).and_return(@agency)
    end
    
    it "loads a collaborating agency" do
      CollaboratingAgency.should_receive(:find).with("1").and_return(@agency)
      put :update, :id => 1
      assigns[:collaborating_agency].should == @agency
    end
    it "updates the agency" do
      @agency.should_receive(:update_attributes)
      put :update, :id => 1
    end
    context "updat succeeds :)" do
      before(:each) do
        @agency.stub(:update_attributes).and_return(true)
      end
      it "sets a flash[:notice]" do
        put :update, :id => 1
        flash[:notice].should_not be_nil
      end
      it "redirects to the collaborating agencies page" do
        put :update, :id => 1
        response.should redirect_to collaborating_agencies_path
      end
    end
    context "update fails :(" do
      before(:each) do
        @agency.stub(:update_attributes).and_return(false)
      end
      it "renders the edit template" do
        put :update, :id => 1
        response.should render_template("collaborating_agencies/edit.html.erb")
      end
    end
  end
  
  describe ":destroy, :id => integer" do
    before(:each) do
      CollaboratingAgency.stub(:destroy).and_return(
        mock_model(CollaboratingAgency, {
          :name => 'Some Agency'
        })
      )
    end
    
    it "destroys the agency of given id" do
      CollaboratingAgency.should_receive(:destroy).with('1')
      delete :destroy, :id => 1
    end
    
    it "sets a flash[:notice]" do
      delete :destroy, :id => 1
      flash[:notice].should_not be_nil
    end
    it "redirects to the collaborating agencies page" do
      delete :destroy, :id => 1
      response.should redirect_to collaborating_agencies_path
    end
  end
end
