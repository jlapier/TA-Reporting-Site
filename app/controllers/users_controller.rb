class UsersController < ApplicationController
  
  before_filter :require_user

  def index
    @users = User.all(:order => 'email')
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Account saved!"
      redirect_to users_path
    else
      render :action => :new
    end
  end

  def show
    @user = @current_user
  end

  def edit
    @user = @current_user
  end

  def update
    @user = @current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to users_path
    else
      render :action => :edit
    end
  end
  
  def destroy
    user = User.destroy(params[:id])
    flash[:notice] = "Deleted #{user.email}."
    redirect_to users_path
  end
end
