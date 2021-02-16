class UsersController < ApplicationController
  before_action :set_user, except: [:index]

  def index
    redirect_to new_user_registration_path
  end

  def show
    @posts = @user.posts_with_reposts.page(params[:page]).without_count.per(5)
  end

  def likes
  end

  def followings
  end

  def followers
  end

  private
  def set_user
    if user_signed_in?
      @user = User.find(params[:id])
    else
      redirect_to root_path
    end
  end
end
