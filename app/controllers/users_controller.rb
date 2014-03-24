class UsersController < ApplicationController
  before_action :signed_in_user,        only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :strict_signed_in_user, only: [:new, :create]
  before_action :correct_user,          only: [:edit, :update]
  before_action :admin_user,            only: :destroy
  before_action :admin_themselves,      only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to RNDeer!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

    def user_params
      params.require(:user).permit(:name, :title, :university, :accounttype, :gpa, :employer, :degree, :email, :password,
                                   :password_confirmation)
    end

    # Before actions

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def strict_signed_in_user
      redirect_to root_path, notice: "You are already signed in." if signed_in?
    end

    def admin_themselves
      redirect_to root_path, error: "Admin user cannot be destroyed!" if User.find(params[:id]).admin?
    end
end