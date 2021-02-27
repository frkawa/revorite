class UsersController < ApplicationController
  before_action :set_user, except: [:index]

  def index
    redirect_to new_user_registration_path
  end

  def show
    @posts = @user.posts_with_reposts.page(params[:page]).without_count.per(PAGENATION_PAGES)
  end

  def likes
    @posts = @user.like_posts.order("likes.created_at DESC").page(params[:page]).without_count.per(PAGENATION_PAGES)
  end

  def followings
    @followings = @user.followings.order("relationships.created_at DESC")
    @followings = Kaminari.paginate_array(@followings).page(params[:page]).per(PAGENATION_PAGES)
  end

  def followers
    @followers = @user.followers.order("relationships.created_at DESC")
    @followers = Kaminari.paginate_array(@followers).page(params[:page]).per(PAGENATION_PAGES)
  end

  private
  def set_user
    @user = User.find(params[:id])
  end
end
