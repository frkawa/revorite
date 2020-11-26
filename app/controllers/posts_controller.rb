class PostsController < ApplicationController

  def index
    @posts = Post.all.includes(:user)
    if user_signed_in?
      @post_count = Post.where(user_id: current_user.id).count
    else
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save 
      redirect_to :root, notice: "投稿に成功しました"
    else
      render :new
    end
  end

  def destroy
    post = Post.find_by(id: params[:id])
    if post.present?
      if post.destroy
        redirect_to root_path, notice: "投稿を削除しました"
      else
        redirect_to root_path, alert: "投稿の削除に失敗しました"
      end
    else
      redirect_to root_path, alert: "投稿が見つかりません"
    end
  end

  private
  def post_params
    params.require(:post).permit(:name, :text, images: []).merge(user_id: current_user.id)
  end
  
end
