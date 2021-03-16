class RepostsController < ApplicationController
  before_action :set_post

  def create
    if Repost.find_by(user_id: current_user.id, post_id: @post.id)
      respond_to do |format|
        format.js {render inline: "location.reload();"}
      end
    else
      @repost = Repost.create(user_id: current_user.id, post_id: @post.id)
    end
  end

  def destroy
    @repost = current_user.reposts.find_by(post_id: @post.id)
    if @repost.present?
      @repost.destroy
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
