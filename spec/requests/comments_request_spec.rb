require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let(:user) { create(:user) }
  before do
    @post = create(:post, user_id: user.id, text: '本文です')
    @comment_params = { user_id: user.id, message: 'コメント本文です' }
  end

  describe 'コメント投稿：POST /posts/post.id/comments' do
    let!(:headers) { { HTTP_REFEREE: 'http://www.example.com/' } }
    context 'コメントに成功した時' do
      it 'リクエストが成功すること' do
        sign_in user
        post post_comments_path(@post.id) , params: { comment: @comment_params }
        expect(response.status).to eq 302
      end
      it 'createが成功すること' do
        sign_in user
        expect do
          post post_comments_path(@post.id) , params: { comment: @comment_params }
        end.to change(Comment, :count).by(+1)
      end
      it '直前のパスにリダイレクトすること' do
        sign_in user
        post post_comments_path(@post.id) , params: { comment: @comment_params }, headers: headers
        expect(response).to redirect_to headers[:HTTP_REFEREE]
      end
      it 'コメントに成功した旨のFlashメッセージが表示されること' do
        sign_in user
        post post_comments_path(@post.id) , params: { comment: @comment_params }
        expect(response.request.flash.notice).to include '投稿にコメントしました'
      end
    end

    context 'コメントに失敗した時' do
      it 'リクエストが成功すること' do
        sign_in user
        @post.destroy
        post post_comments_path(@post.id) , params: { comment: @comment_params }
        expect(response.status).to eq 302
      end
      it 'createが失敗すること' do
        sign_in user
        @post.destroy
        expect do
          post post_comments_path(@post.id) , params: { comment: @comment_params }
        end.not_to change(Comment, :count)
      end
      it '直前のパスにリダイレクトすること' do
        sign_in user
        @post.destroy
        post post_comments_path(@post.id), params: { comment: @comment_params }, headers: headers
        expect(response).to redirect_to headers[:HTTP_REFEREE]
      end
      it 'コメントに失敗した旨のFlashメッセージが表示されること' do
        sign_in user
        @post.destroy
        post post_comments_path(@post.id) , params: { comment: @comment_params }
        expect(response.request.flash.alert).to include 'コメントに失敗しました'
      end
    end
  end

  describe 'コメント削除：DELETE /posts/post.id/comments/comment.id' do
    let!(:headers) { { HTTP_REFEREE: 'http://www.example.com/' } }
    before do
      sign_in user
      post post_comments_path(@post.id) , params: { comment: @comment_params }
      @comment = Comment.find_by(post_id: @post.id)
    end

    context 'コメント削除に成功した時' do
      it 'リクエストが成功すること' do
        delete post_comment_path(post_id: @post.id, id: @comment.id)
        expect(response.status).to eq 302
      end
      it 'deleteが成功すること' do
        expect do
          delete post_comment_path(post_id: @post.id, id: @comment.id)
        end.to change(Comment, :count).by(-1)
      end
      it '直前のパスにリダイレクトすること' do
        delete post_comment_path(post_id: @post.id, id: @comment.id), headers: headers
        expect(response).to redirect_to headers[:HTTP_REFEREE]
      end
      it 'コメント削除に成功した旨のFlashメッセージが表示されること' do
        delete post_comment_path(post_id: @post.id, id: @comment.id)
        expect(response.request.flash.notice).to include 'コメントを削除しました'
      end
    end

    context 'コメント削除に失敗した時' do
      it 'リクエストが成功すること' do
        @comment.destroy
        delete post_comment_path(post_id: @post.id, id: @comment.id)
        expect(response.status).to eq 302
      end
      it 'deleteが失敗すること' do
        @comment.destroy
        expect do
          delete post_comment_path(post_id: @post.id, id: @comment.id)
        end.not_to change(Comment, :count)
      end
      it '直前のパスにリダイレクトすること' do
        @comment.destroy
        delete post_comment_path(post_id: @post.id, id: @comment.id), headers: headers
        expect(response).to redirect_to headers[:HTTP_REFEREE]
      end
      it 'コメント削除に失敗した旨のFlashメッセージが表示されること' do
        @comment.destroy
        delete post_comment_path(post_id: @post.id, id: @comment.id)
        expect(response.request.flash.alert).to include 'コメントが見つかりません'
      end
    end
  end
end
