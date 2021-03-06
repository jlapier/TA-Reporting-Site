require 'spec_helper'

describe CriteriaController do
  def mock_criterium(stubs={})
    @mock_criterium ||= mock_model(Criterium, stubs)
  end
  before(:each) do
    controller.stub(:require_user).and_return(true)
    @post_params = {
      :kind => "Objective",
      :number => 2,
      :name => "Test Objective",
      :description => "develop practical, efficient, cost-effective, and sustainable strategies for collecting and using data to improve secondary transition and post-secondary outcomes."
    }
  end
  describe ":index" do
    it "assigns all criteria as @criteria" do
      Criterium.stub(:all).with(:order => 'number').and_return([mock_criterium])
      get :index
      assigns[:criteria].should == [mock_criterium]
    end
  end
  describe ":new" do
    it "assigns a new criterium as @criterium" do
      Criterium.should_receive(:new).and_return(mock_criterium)
      get :new
      assigns[:criterium].should equal(mock_criterium)
    end
  end

  describe ":edit, :id => integer" do
    before(:each) do
      @criterium = mock_model(Criterium)
      Criterium.stub(:find).and_return(@criterium)
    end
    it "loads a criterium as @criterium" do
      get :edit, :id => 1
      assigns[:criterium].should eql @criterium
    end
    it "renders the edit template" do
      get :edit, :id => 1
      response.should render_template("criteria/edit")
    end
  end
  %w( TaDeliveryMethod GrantActivity IntensityLevel Objective TaCategory ).each do |klass|
    describe ":create, #{klass.underscore.to_sym} => {}" do
      before(:each) do
        @stubs = {
          :save => nil,
          :kind => klass
        }
      end
      it "re-assigns params[#{klass.underscore.to_sym}] to params[:criterium]" do
        Criterium.stub(:new).and_return(mock_criterium(@stubs))
        post :create, "#{klass.underscore.to_sym}" => {:these => 'params'}
        request.params[:criterium].should eql({"these" => "params"})
      end

      describe "with valid params" do
        it "assigns a newly created criterium as @criterium" do
          Criterium.stub(:new).with({'these' => 'params'}).and_return(mock_criterium(@stubs))
          post :create, "#{klass.underscore.to_sym}" => {:these => 'params'}
          assigns[:criterium].should equal(mock_criterium)
        end

        it "redirects to the criterium list UNLESS criterium is a GrantActivity" do
          Criterium.stub(:new).and_return(mock_criterium(@stubs.merge!({
            :save => true
          })))
          post :create, "#{klass.underscore.to_sym}" => {}
          response.should redirect_to(criteria_url)
        end unless klass == 'GrantActivity'
        
        it "redirects to the edit criterium page IF criterium is a GrantActivity" do
          Criterium.stub(:new).and_return(mock_criterium(@stubs.merge!({
            :save => true
          })))
          post :create, "#{klass.underscore.to_sym}" => {}
          response.should redirect_to(edit_criterium_url(mock_criterium))
        end if klass == 'GrantActivity'
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved criterium as @criterium" do
          Criterium.stub(:new).with({'these' => 'params'}).and_return(mock_criterium(@stubs))
          post :create, "#{klass.underscore.to_sym}" => {:these => 'params'}
          assigns[:criterium].should equal(mock_criterium)
        end

        it "re-renders the 'new' template" do
          Criterium.stub(:new).and_return(mock_criterium(@stubs))
          post :create, "#{klass.underscore.to_sym}" => {}
          response.should render_template('new')
        end
      end

    end
    
    describe ":update, :id => integer, #{klass.underscore.to_sym} => {}" do
      before(:each) do
        @stubs = {
          :update_attributes => nil,
          :kind => klass
        }
      end
      it "re-assigns params[#{klass.underscore.to_sym}] to params[:criterium]" do
        Criterium.stub(:find).and_return(mock_criterium(@stubs))
        put :update, :id => 1, "#{klass.underscore.to_sym}" => {:these => 'params'}
        request.params[:criterium].should eql({"these" => "params"})
      end
      describe "with valid params" do
        it "updates the requested criterium" do
          Criterium.should_receive(:find).with("37").and_return(mock_criterium(@stubs))
          mock_criterium.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :criterium => {:these => 'params'}
        end

        it "assigns the requested criterium as @criterium" do
          Criterium.stub(:find).and_return(mock_criterium(@stubs.merge!({
            :update_attributes => true
          })))
          put :update, :id => "1"
          assigns[:criterium].should equal(mock_criterium)
        end

        it "redirects to the criterium list" do
          Criterium.stub(:find).and_return(mock_criterium(@stubs.merge!({
            :update_attributes => true
          })))
          put :update, :id => "1"
          response.should redirect_to(criteria_url)
        end
      end

      describe "with invalid params" do
        it "updates the requested criterium" do
          Criterium.should_receive(:find).with("37").and_return(mock_criterium(@stubs))
          mock_criterium.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :criterium => {:these => 'params'}
        end

        it "assigns the criterium as @criterium" do
          Criterium.stub(:find).and_return(mock_criterium(@stubs))
          put :update, :id => "1"
          assigns[:criterium].should equal(mock_criterium)
        end

        it "re-renders the 'edit' template" do
          Criterium.stub(:find).and_return(mock_criterium(@stubs))
          put :update, :id => "1"
          response.should render_template('edit')
        end
      end

    end
    
  end

  describe "DELETE destroy" do
    it "destroys the requested criterium" do
      Criterium.should_receive(:find).with("37").and_return(mock_criterium)
      mock_criterium.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the criteria list" do
      Criterium.stub(:find).and_return(mock_criterium(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(criteria_url)
    end
  end

end
