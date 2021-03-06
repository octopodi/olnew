class UsersController < ApplicationController
  before_filter :authenticate,    :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user,    :only => [:edit, :update]
  before_filter :admin_user,      :only => :destroy
  before_filter :signed_in_user,  :only => [:new, :create]


  def show
    @user = User.find(params[:id])
    if ! @user.name.blank?
      @title = @user.name
    else
      @title = nil
    end
  end

  def new
    @user = User.new
    @title = "Sign up"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to OLN!"
      redirect_to @user
    else
      @title = "Sign up"
      render 'new'
    end
  end

  def edit
    @title = "Edit profile"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit profile"
      render 'edit'
    end
  end

  def index
    @title = "Guild Members"
    @users = User.order(:name).page(params[:page])
  end

  def destroy
    to_destroy_user = User.find(params[:id])
    if to_destroy_user == @current_user
      flash[:error] = "Cannot destroy current user."
      redirect_to users_path
    else
      to_destroy_user.destroy
      flash[:success] = "User destroyed."
      redirect_to users_path
    end
  end


  private

    def authenticate
      deny_access unless signed_in?
      # deny_access defined in SessionsHelper
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
      # current_user? method defined in SessionsHelper
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def signed_in_user
      redirect_to(root_path) if signed_in?
    end

end
