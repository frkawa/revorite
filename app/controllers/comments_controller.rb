class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    
    if @comment.save
      redirect_back fallback_location: root_path, notice: "投稿にコメントしました"
    else
      redirect_back fallback_location: root_path, alert: "コメントに失敗しました"
    end
  end

  def destroy
    comment = Comment.find_by(id: params[:id])
    if comment.present?
      if comment.destroy
        redirect_back fallback_location: root_path, notice: "コメントを削除しました"
      else
        redirect_back fallback_location: root_path, alert: "コメントの削除に失敗しました"
      end
    else
      redirect_back fallback_location: root_path, alert: "コメントが見つかりません"
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:message, images: []).merge(user_id: current_user.id, post_id: params[:post_id])
  end
end
