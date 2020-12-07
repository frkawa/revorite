class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      redirect_to :root, notice: "投稿にコメントしました"
    else
      redirect_to :root, alert: "コメントに失敗しました"
    end
  end

  def destroy
    comment = Comment.find_by(id: params[:id])
    if comment.present?
      if comment.destroy
        redirect_to :root, notice: "コメントを削除しました"
      else
        redirect_to :root, alert: "コメントの削除に失敗しました"
      end
    else
      redirect_to :root, alert: "コメントが見つかりません"
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:message).merge(user_id: current_user.id, post_id: params[:post_id])
  end
end
