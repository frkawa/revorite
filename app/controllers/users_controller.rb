class UsersController < ApplicationController
  before_action :set_user, except: [:index]

  def index
    redirect_to new_user_registration_path
  end

  def show
    @posts = @user.posts_with_reposts
  end

  def likes
  end

  def followings
  end

  def followers
  end

  private
  def set_user
    @user = User.find(params[:id])
  end
end
