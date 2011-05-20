class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  before_filter :not_signed_in_user,   :only => [:new, :create]  # my solution to exercise 10.3

  def index
    @title = "All users"
    #@users = User.all
    #@users = User.page(params[:page]).per(10) # kaminari pagination
	@users = User.scoped.paginate :page => params[:page] # will_paginate pagination
	
  end

  def show
    @user = User.find(params[:id])
	@microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name
  end
  
  def new
    @title = "Sign up"
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
	  sign_in @user
	  flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign up"
	  @user.password = @user.password_confirmation = nil

      render 'new'
    end
  end

  def edit
    #@user = User.find(params[:id])
    @title = "Edit user"
  end

  def update
    #@user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end

  private

    def correct_user
      @user = User.find(params[:id])
	  redirect_to(root_path) unless current_user?(@user)
    end
    
	def admin_user
	  if !current_user.admin? || User.find(params[:id]).admin? # user must be an admin and must be deleting a non-admin account
	    redirect_to(root_path)
	  end
    end

	def not_signed_in_user
	  redirect_to(root_path, :alert => "You cannot sign up for a new account because you are currently signed in.") if current_user
	end
end
