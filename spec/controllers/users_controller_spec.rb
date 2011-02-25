require 'spec_helper'

describe UsersController do
  let(:user){ mock_model(User) }
  let(:current_user){ mock_model(User) }
  let(:user_session) do
    mock(UserSession, {
      :user => current_user,
      :name => ''
    })
  end
  before(:each) do
    controller.stub(:current_user_session){ user_session }
  end

  describe ":index" do
    before(:each) do
      User.should_receive(:all){ [user] }
    end
    it "loads all users as @users" do
      get :index
      assigns(:users).should eq [user]
    end
    it "renders the index template" do
      get :index
      response.should render_template("users/index")
    end
  end
  
  context "new User" do
    before(:each) do
      User.should_receive(:new){ user }
    end
    describe ":new" do
      it "instantiates a new user as @user" do
        get :new
        assigns(:user).should eq user
      end
      it "renders the new template" do
        get :new
        response.should render_template("users/new")
      end
    end
    
    describe ":create, :user => {}" do
      let(:params) do
        {:user => {:first_name => 'He', :last_name => 'Llo'}}
      end
      before(:each) do
        user.stub(:save){ nil }
        User.stub(:new){ user }
      end
      it "instantiates a new user as @user" do
        post :create, params
        assigns(:user).should eq user
      end
      it "saves the user" do
        user.should_receive(:save)
        post :create, params
      end
      context "save succeeds :)" do
        before(:each) do
          user.stub(:save){ true }
        end
        it "sets a flash[:notice]" do
          post :create, params
          flash[:notice].should_not be_nil
        end
        it "redirects to the users page" do
          post :create, params
          response.should redirect_to users_path
        end
      end
      context "save fails :(" do
        before(:each) do
          user.stub(:save){ false }
        end
        it "renders the new template" do
          post :create, params
          response.should render_template("users/new")
        end
      end
    end
  end
  
  context "existing User" do
    let(:params) do
      {:id => 1}
    end
    describe ":edit" do
      it "loads a user as @user from current_user" do
        get :edit, params
        assigns(:user).should eq current_user
      end
      it "renders the edit template" do
        get :edit, params
        response.should render_template("users/edit")
      end
    end
    describe ":show" do
      it "loads a user as @user from current_user" do
        get :show, params
        assigns(:user).should eq current_user
      end
      it "renders the show template" do
        get :show, params
        response.should render_template("users/show")
      end
    end
    describe ":update" do
      before(:each) do
        params.merge!({:user => {:email => 'new.email@test.com'}})
        # using should_receive here somehow prevents any future return val from being changed eg false
        current_user.stub(:update_attributes).with(params[:user].stringify_keys){ true }
      end
      it "loads a user as @user from current_user" do
        put :update, params
        assigns(:user).should eq current_user
      end
      it "updates the user" do
        put :update, params
      end
      context "update succeeds :)" do
        it "sets a flash[:notice]" do
          put :update, params
          flash[:notice].should_not be_nil
        end
        it "redirects to the users page" do
          put :update, params
          response.should redirect_to users_path
        end
      end
      context "update fails :(" do
        it "renders the edit template" do
          current_user.stub(:update_attributes).with(params[:user].stringify_keys){ false }
          put :update, params
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
        User.should_receive(:destroy).with(1)
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
