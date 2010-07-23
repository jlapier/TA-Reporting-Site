require 'spec_helper'

describe UsersController do

  before(:each) do
    @current_user = mock_model(User)
    controller.stub(:current_user_session).and_return(
      mock_model(UserSession, {
        :user => @current_user,
        :name => ''
      })
    )
  end

  describe ":index" do
    before(:each) do
      @user = mock_model(User)
      User.stub(:all).and_return([@user])
    end
    it "loads all users as @users" do
      User.should_receive(:all).and_return([@user])
      get :index
      assigns[:users].should == [@user]
    end
    it "renders the index template" do
      get :index
      response.should render_template("users/index")
    end
  end
  
  context "new User" do
    before(:each) do
      @user = mock_model(User).as_new_record
      User.stub(:new).and_return(@user)
    end
    describe ":new" do
      it "instantiates a new user as @user" do
        User.should_receive(:new).and_return(@user)
        get :new
        assigns[:user].should == @user
      end
      it "renders the new template" do
        get :new
        response.should render_template("users/new")
      end
    end
    
    describe ":create, :user => {}" do
      before(:each) do
        @user.stub(:save).and_return(nil)
      end
      it "instantiates a new user as @user" do
        User.should_receive(:new).and_return(@user)
        post :create
        assigns[:user].should == @user
      end
      it "saves the user" do
        @user.should_receive(:save)
        post :create
      end
      context "save succeeds :)" do
        before(:each) do
          @user.stub(:save).and_return(true)
        end
        it "sets a flash[:notice]" do
          post :create
          flash[:notice].should_not be_nil
        end
        it "redirects to the users page" do
          post :create
          response.should redirect_to users_path
        end
      end
      context "save fails :(" do
        before(:each) do
          @user.stub(:save).and_return(false)
        end
        it "renders the new template" do
          post :create
          response.should render_template("users/new")
        end
      end
    end
  end
  
  context "existing User" do
    describe ":edit" do
      it "loads a user as @user from @current_user" do
        get :edit
        assigns[:user].should == @current_user
      end
      it "renders the edit template" do
        get :edit
        response.should render_template("users/edit")
      end
    end
    describe ":show" do
      it "loads a user as @user from @current_user" do
        get :show
        assigns[:user].should == @current_user
      end
      it "renders the show template" do
        get :show
        response.should render_template("users/show")
      end
    end
    describe ":update" do
      before(:each) do
        @current_user.stub(:update_attributes).and_return(nil)
      end
      it "loads a user as @user from @current_user" do
        put :update
        assigns[:user].should == @current_user
      end
      it "updates the user" do
        @current_user.should_receive(:update_attributes).with({
          'email' => 'new.email@test.com'
        })
        put :update, :user => {:email => 'new.email@test.com'}
      end
      context "update succeeds :)" do
        before(:each) do
          @current_user.stub(:update_attributes).and_return(true)
        end
        it "sets a flash[:notice]" do
          put :update
          flash[:notice].should_not be_nil
        end
        it "redirects to the users page" do
          put :update
          response.should redirect_to users_path
        end
      end
      context "update fails :(" do
        before(:each) do
          @current_user.stub(:update_attributes).and_return(false)
        end
        it "renders the edit template" do
          put :update
          response.should render_template("users/edit")
        end
      end
    end
    describe ":destroy, :id => integer" do
      before(:each) do
        User.stub(:destroy).and_return(mock_model(User, {
          :email => 'test@example.com'
        }))
      end
      it "destroys the user of given id" do
        User.should_receive(:destroy).with("1")
        delete :destroy, :id => 1
      end
      it "sets a flash[:notice]" do
        delete :destroy, :id => 1
        flash[:notice].should_not be_nil
      end
      it "redirects to the users page" do
        delete :destroy, :id => 1
        response.should redirect_to users_path
      end
    end
  end

end
