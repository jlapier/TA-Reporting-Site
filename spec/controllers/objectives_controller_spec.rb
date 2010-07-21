require 'spec_helper'

describe ObjectivesController do

  def mock_objective(stubs={})
    @mock_objective ||= mock_model(Objective, stubs)
  end

  describe "GET index" do
    it "assigns all objectives as @objectives" do
      Objective.stub(:find).with(:all, :order => 'number').and_return([mock_objective])
      get :index
      assigns[:objectives].should == [mock_objective]
    end
  end

  describe "GET show" do
    it "assigns the requested objective as @objective" do
      Objective.stub(:find).with("37").and_return(mock_objective)
      get :show, :id => "37"
      assigns[:objective].should equal(mock_objective)
    end
  end

  describe "GET new" do
    it "assigns a new objective as @objective" do
      Objective.stub(:new).and_return(mock_objective)
      get :new
      assigns[:objective].should equal(mock_objective)
    end
  end

  describe "GET edit" do
    it "assigns the requested objective as @objective" do
      Objective.stub(:find).with("37").and_return(mock_objective)
      get :edit, :id => "37"
      assigns[:objective].should equal(mock_objective)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created objective as @objective" do
        Objective.stub(:new).with({'these' => 'params'}).and_return(mock_objective(:save => true))
        post :create, :objective => {:these => 'params'}
        assigns[:objective].should equal(mock_objective)
      end

      it "redirects to the objective list" do
        Objective.stub(:new).and_return(mock_objective(:save => true))
        post :create, :objective => {}
        response.should redirect_to(objectives_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved objective as @objective" do
        Objective.stub(:new).with({'these' => 'params'}).and_return(mock_objective(:save => false))
        post :create, :objective => {:these => 'params'}
        assigns[:objective].should equal(mock_objective)
      end

      it "re-renders the 'new' template" do
        Objective.stub(:new).and_return(mock_objective(:save => false))
        post :create, :objective => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested objective" do
        Objective.should_receive(:find).with("37").and_return(mock_objective)
        mock_objective.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :objective => {:these => 'params'}
      end

      it "assigns the requested objective as @objective" do
        Objective.stub(:find).and_return(mock_objective(:update_attributes => true))
        put :update, :id => "1"
        assigns[:objective].should equal(mock_objective)
      end

      it "redirects to the objective list" do
        Objective.stub(:find).and_return(mock_objective(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(objectives_url)
      end
    end

    describe "with invalid params" do
      it "updates the requested objective" do
        Objective.should_receive(:find).with("37").and_return(mock_objective)
        mock_objective.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :objective => {:these => 'params'}
      end

      it "assigns the objective as @objective" do
        Objective.stub(:find).and_return(mock_objective(:update_attributes => false))
        put :update, :id => "1"
        assigns[:objective].should equal(mock_objective)
      end

      it "re-renders the 'edit' template" do
        Objective.stub(:find).and_return(mock_objective(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested objective" do
      Objective.should_receive(:find).with("37").and_return(mock_objective)
      mock_objective.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the objectives list" do
      Objective.stub(:find).and_return(mock_objective(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(objectives_url)
    end
  end

end
