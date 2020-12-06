class LikesController < ApplicationController
  before_action :set_post

  def create
    if Like.find_by(user_id: current_user.id, post_id: @post.id)
      redirect_to root_path, alert: '既にお気に入りに追加済みです'
    else
      @like = Like.create(user_id: current_user.id, post_id: @post.id)
    end
  end

  def destroy
    @like = current_user.likes.find_by(post_id: @post.id)
    if @like.present?
      @like.destroy
    else
      redirect_to root_path, alert: '既にお気に入りから削除済みです'
    end
  end

  private
  def set_post
    @post = Post.find_by(id: params[:post_id])
    if @post.nil?
      redirect_to root_path, alert: '該当の投稿が見つかりません'
    end
  end
end
