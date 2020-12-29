class UsersController < ApplicationController
  before_action :set_user

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
