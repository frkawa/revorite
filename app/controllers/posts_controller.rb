class PostsController < ApplicationController

  def index
    @posts = Post.with_attached_images.includes([:user, :review, :comments])
    if user_signed_in?
      @user = User.find(current_user.id)
      @post_count = Post.where(user_id: current_user.id).count
    else
    end
  end

  def new
    @post = Post.new
  end

  def create
    if params[:post][:rev_flg] == '0'  # 「レビューをする」にチェックが無い場合
      @post = Post.new(post_params)
    else
      @post = Post.new(post_params_with_review)
    end  
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
    params.require(:post).permit(:rev_flg, :text, images: []).merge(user_id: current_user.id)
  end

  def post_params_with_review
    params.require(:post).permit(:rev_flg, :text, images: [], review_attributes:[:rate, :title, :price]).merge(user_id: current_user.id)
  end

end