class LikesController < ApplicationController
  before_action :set_post

  def create
    if Like.find_by(user_id: current_user.id, post_id: @post.id)
      respond_to do |format|
        format.js {render inline: "location.reload();"}
      end
    else
      @like = Like.create(user_id: current_user.id, post_id: @post.id)
    end
  end

  def destroy
    @like = current_user.likes.find_by(post_id: @post.id)
    if @like.present?
      @like.destroy
    else
      respond_to do |format|
        format.js {render inline: "location.reload();"}
      end
    end
  end

  private
  def set_post
    @post = Post.find_by(id: params[:post_id])
    if @post.nil?
      respond_to do |format|
        format.js {render inline: "location.reload();"}
      end
    end
  end
end
