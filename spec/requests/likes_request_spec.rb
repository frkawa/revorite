require 'rails_helper'

RSpec.describe "Likes", type: :request do
  let(:user) { create(:user) }
  before do
    @post = create(:post, user_id: user.id, text: '本文です')
  end

  describe 'お気に入りの登録：POST /posts/:post_id/likes' do
    context 'お気に入り登録が成功した時' do
      it 'リクエストが成功すること' do
        sign_in user
        post post_likes_path(@post.id), xhr: true
        expect(response.status).to eq 200
      end
      it 'Javascript形式で返すこと' do
        sign_in user
        post post_likes_path(@post.id), xhr: true
        expect(response.content_type).to eq "text/javascript"
      end
      it 'createが成功すること' do
        sign_in user
        expect do
          post post_likes_path(@post.id), xhr: true
        end.to change(Like, :count).by(+1)
      end
    end

    context 'お気に入り登録が失敗した時' do
      it 'リクエストが成功すること' do
        sign_in user
        @post.destroy
        post post_likes_path(@post.id), xhr: true
        expect(response.status).to eq 200
      end
      it 'Javascript形式で返すこと' do
        sign_in user
        @post.destroy
        post post_likes_path(@post.id), xhr: true
        expect(response.content_type).to eq "text/javascript"
      end
      it 'createが失敗すること' do
        sign_in user
        @post.destroy
        expect do
          post post_likes_path(@post.id), xhr: true
        end.not_to change(Like, :count)
      end
    end
  end

  describe 'お気に入りの削除：DELETE /posts/:post_id/likes/:id' do
    before do
      sign_in user
      post post_likes_path(@post.id), xhr: true
      @like = Like.find_by(user_id: user.id)
    end

    context 'お気に入り削除が成功した時' do
      it 'リクエストが成功すること' do
        delete post_like_path(@post.id, @like.id), xhr: true
        expect(response.status).to eq 200
      end
      it 'Javascript形式で返すこと' do
        delete post_like_path(@post.id, @like.id), xhr: true
        expect(response.content_type).to eq "text/javascript"
      end
      it 'deleteが成功すること' do
        expect do
          delete post_like_path(@post.id, @like.id), xhr: true
        end.to change(Like, :count).by(-1)
      end
    end

    context 'お気に入り削除が失敗した時' do
      it 'リクエストが成功すること' do
        @post.destroy
        delete post_like_path(@post.id, @like.id), xhr: true
        expect(response.status).to eq 200
      end
      it 'Javascript形式で返すこと' do
        @post.destroy
        delete post_like_path(@post.id, @like.id), xhr: true
        expect(response.content_type).to eq "text/javascript"
      end
      it 'createが失敗すること' do
        sign_in user
        @post.destroy
        expect do
          delete post_like_path(@post.id, @like.id), xhr: true
        end.not_to change(Like, :count)
      end
    end
  end
end
