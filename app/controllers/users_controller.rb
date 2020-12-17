class UsersController < ApplicationController
  before_action :set_user

  def show
    @user = User.find(params[:id])
    @posts = Post.where(user_id: @user.id).with_attached_images.includes([:user, :review, :comments])
  end

  def likes
    
  end

  private
  def set_user
    @user = User.find(params[:id])
  end
end
