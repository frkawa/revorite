require 'rails_helper'

RSpec.describe "Reposts", type: :request do
  let(:user) { create(:user) }
  let(:another_user) { create(:another_user) }
  before do
    @post = create(:post, user_id: another_user.id, text: '本文です')
  end

  describe 'リポスト：POST /posts/:post_id/reposts' do
    context 'リポストが成功した時' do
      it 'リクエストが成功すること' do
        sign_in user
        post post_reposts_path(@post.id), xhr: true
        expect(response.status).to eq 200
      end
      it 'Javascript形式で返すこと' do
        sign_in user
        post post_reposts_path(@post.id), xhr: true
        expect(response.content_type).to eq "text/javascript"
      end
      it 'createが成功すること' do
        sign_in user
        expect do
          post post_reposts_path(@post.id), xhr: true
        end.to change(Repost, :count).by(+1)
      end
    end

    context 'リポストが失敗した時' do
      it 'リクエストが成功すること' do
        sign_in user
        @post.destroy
        post post_reposts_path(@post.id), xhr: true
        expect(response.status).to eq 200
      end
      it 'Javascript形式で返すこと' do
        sign_in user
        @post.destroy
        post post_reposts_path(@post.id), xhr: true
        expect(response.content_type).to eq "text/javascript"
      end
      it 'createが失敗すること' do
        sign_in user
        @post.destroy
        expect do
          post post_reposts_path(@post.id), xhr: true
        end.not_to change(Repost, :count)
      end
    end
  end

  describe 'リポストの取り消し：DELETE /posts/:post_id/reposts/:id' do
    before do
      sign_in user
      post post_reposts_path(@post.id), xhr: true
      @repost = Repost.find_by(user_id: user.id)
    end

    context 'リポストの取り消しが成功した時' do
      it 'リクエストが成功すること' do
        delete post_repost_path(@post.id, @repost.id), xhr: true
        expect(response.status).to eq 200
      end
      it 'Javascript形式で返すこと' do
        delete post_repost_path(@post.id, @repost.id), xhr: true
        expect(response.content_type).to eq "text/javascript"
      end
      it 'deleteが成功すること' do
        expect do
          delete post_repost_path(@post.id, @repost.id), xhr: true
        end.to change(Repost, :count).by(-1)
      end
    end

    context 'リポストの取り消しが失敗した時' do
      it 'リクエストが成功すること' do
        @post.destroy
        delete post_repost_path(@post.id, @repost.id), xhr: true
        expect(response.status).to eq 200
      end
      it 'Javascript形式で返すこと' do
        @post.destroy
        delete post_repost_path(@post.id, @repost.id), xhr: true
        expect(response.content_type).to eq "text/javascript"
      end
      it 'deleteが失敗すること' do
        sign_in user
        @post.destroy
        expect do
          delete post_repost_path(@post.id, @repost.id), xhr: true
        end.not_to change(Repost, :count)
      end
    end
  end
end
