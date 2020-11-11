class PostsController < ApplicationController

  def index
    @posts = Post.all.includes(:user)
  end

  def new
    @post = Post.new
  end

  def create
    Post.create(post_params)
    redirect_to :root
  end

  private
  def post_params
    params.require(:post).permit(:name, :text).merge(user_id: current_user.id)
  end
  
end
