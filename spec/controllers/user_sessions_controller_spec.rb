require 'spec_helper'

describe UserSessionsController do
  context "anonymous user" do
    before(:each) do
      controller.stub(:require_no_user).and_return(true)
    end
    describe ":new" do
      it "starts a new user session" do
        @user_session = mock_model(UserSession).as_new_record
        UserSession.should_receive(:new).and_return(@user_session)
        get :new
        assigns[:user_session].should == @user_session
      end
      it "renders the new template" do
        get :new
        response.should render_template("user_sessions/new")
      end
    end
    describe ":create" do
      before(:each) do
        @user_session = mock_model(UserSession, {
          :save => nil
        }).as_new_record
        UserSession.stub(:new).and_return(@user_session)
      end
      it "starts a new user session" do
        UserSession.should_receive(:new).and_return(@user_session)
        post :create
        assigns[:user_session].should == @user_session
      end
      it "saves the user session" do
        @user_session.should_receive(:save)
        post :create
      end
      context "save succeeds :)" do
        before(:each) do
          @user_session.stub(:save).and_yield(true)
          UserSession.stub(:new).and_return(@user_session)
        end
        it "sets a flash[:notice]" do
          post :create
          flash[:notice].should_not be_nil
        end
        it "redirects to the home page" do
          post :create
          response.should redirect_to root_path
        end
      end
      context "save fails :(" do
        before(:each) do
          @user_session.stub(:save).and_yield(false)
        end
        it "renders the new template" do
          post :create
          response.should render_template("user_sessions/new")
        end
      end
    end
  end
  context "authenticated user" do
    before(:each) do
      @user = mock_model(User)
      @user_session = mock_model(UserSession, {
        :user => @user,
        :destroy => nil
      })
      controller.stub(:current_user_session).and_return(@user_session)
    end
    describe ":destroy" do
      it "destroys the current session" do
        @user_session.should_receive(:destroy)
        delete :destroy
      end
      it "sets a flash[:notice]" do
        delete :destroy
        flash[:notice].should_not be_nil
      end
      it "redirects to the login page" do
        delete :destroy
        response.should redirect_to new_user_session_path
      end
    end
  end
end
