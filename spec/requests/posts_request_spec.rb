require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:user) { create(:user) }
  before do
    @another_user1 = create(:another_user)
    @another_user2 = create(:another_user, email: "test03@example.com")
    @another_user1_post = Post.create(text: 'another_user1です', user_id: @another_user1.id)
    @another_user2_post = Post.create(text: 'another_user2です', user_id: @another_user2.id)
    @my_post = Post.create(text: '私です', user_id: user.id)
    user.follow(@another_user1)
  end

  describe '新規投稿画面遷移：GET /posts/new' do
    context 'ログイン済みの場合' do
      it 'リクエストが成功すること' do
        sign_in user
        get new_post_path
        expect(response.status).to eq 200
      end
    end
    
    context '未ログインの場合' do
      it 'リクエストが成功すること' do
        get new_post_path
        expect(response.status).to eq 302
      end
      it 'ログインページにリダイレクトすること' do
        get new_post_path
        expect(response).to redirect_to new_user_session_path
      end
      it '投稿前にログインする必要がある旨のFlashメッセージが表示されること' do
        get new_post_path
        expect(response.request.flash.alert).to include 'ログインまたは登録が必要です'
      end
    end
  end

  describe '新規投稿（レビュー無し）：POST /posts' do
    let(:rev_flg) { '0' }  # 「レビューをする」チェック無し
    context '有効なパラメータの時' do
      it 'リクエストが成功すること' do
        sign_in user
        post posts_path , params: { post: { rev_flg: rev_flg, text: '本文です' } }
        expect(response.status).to eq 302
      end
      it 'createが成功すること' do
        sign_in user
        expect do
          post posts_path , params: { post: { rev_flg: rev_flg, text: '本文です' } }
        end.to change(Post, :count).by(+1)
      end
      it 'ルートにリダイレクトすること' do
        sign_in user
        post posts_path , params: { post: { rev_flg: rev_flg, text: '本文です' } }
        expect(response).to redirect_to root_path
      end
      it '投稿に成功した旨のFlashメッセージが表示されること' do
        sign_in user
        post posts_path , params: { post: { rev_flg: rev_flg, text: '本文です' } }
        expect(response.request.flash.notice).to include '投稿に成功しました'
      end
    end

    context '無効なパラメータの時' do
      it 'リクエストが成功すること' do
        sign_in user
        post posts_path , params: { post: { rev_flg: rev_flg, text: '' } }
        expect(response.status).to eq 200
      end
      it 'createが失敗すること' do
        sign_in user
        expect do
          post posts_path , params: { post: { rev_flg: rev_flg, text: '' } }
        end.not_to change(Post, :count)
      end
      it 'エラー表示されること' do
        sign_in user
        post posts_path , params: { post: { rev_flg: rev_flg, text: '' } }
        expect(response.body).to include '本文を入力してください'
      end
    end

    context 'ログインしていない時' do
      it 'リクエストが成功すること' do
        post posts_path , params: { post: { rev_flg: rev_flg, text: '本文です' } }
        expect(response.status).to eq 302
      end
      it 'createが失敗すること' do
        expect do
          post posts_path , params: { post: { rev_flg: rev_flg, text: '本文です' } }
        end.not_to change(Post, :count)
      end
      it 'ログインページにリダイレクトすること' do
        post posts_path , params: { post: { rev_flg: rev_flg, text: '本文です' } }
        expect(response).to redirect_to new_user_session_path
      end
      it '投稿前にログインする必要がある旨のFlashメッセージが表示されること' do
        post posts_path , params: { post: { rev_flg: rev_flg, text: '本文です' } }
        expect(response.request.flash.alert).to include 'ログインまたは登録が必要です'
      end
    end
  end

  describe '新規投稿（レビューあり）：POST /posts' do
    let(:rev_flg) { '1' }  # 「レビューをする」チェックあり
    context '有効なパラメータの時' do
      it 'リクエストが成功すること' do
        sign_in user
        post posts_path , params: { post: { rev_flg: rev_flg, text: '本文です', review_attributes: { title: 'レビュータイトルです', rate: '3.5' } } }
        expect(response.status).to eq 302
      end
      it 'createが成功すること' do
        sign_in user
        expect do
          post posts_path , params: { post: { rev_flg: rev_flg, text: '本文です', review_attributes: { title: 'レビュータイトルです', rate: '3.5' } } }
        end.to change(Post, :count).by(+1) && change(Review, :count).by(+1)
      end
      it 'ルートにリダイレクトすること' do
        sign_in user
        post posts_path , params: { post: { rev_flg: rev_flg, text: '本文です', review_attributes: { title: 'レビュータイトルです', rate: '3.5' } } }
        expect(response).to redirect_to root_path
      end
      it '投稿に成功した旨のFlashメッセージが表示されること' do
        sign_in user
        post posts_path , params: { post: { rev_flg: rev_flg, text: '本文です', review_attributes: { title: 'レビュータイトルです', rate: '3.5' } } }
        expect(response.request.flash.notice).to include '投稿に成功しました'
      end
    end

    context '無効なパラメータの時' do
      it 'リクエストが成功すること' do
        sign_in user
        post posts_path , params: { post: { rev_flg: rev_flg, text: '本文です', review_attributes: { title: '', rate: '3.5' } } }
        expect(response.status).to eq 200
      end
      it 'createが失敗すること' do
        sign_in user
        expect do
          post posts_path , params: { post: { rev_flg: rev_flg, text: '本文です', review_attributes: { title: '', rate: '3.5' } } }
        end.not_to change(Post, :count) && change(Review, :count)
      end
      it 'エラー表示されること' do
        sign_in user
        post posts_path , params: { post: { rev_flg: rev_flg, text: '本文です', review_attributes: { title: '', rate: '3.5' } } }
        expect(response.body).to include 'レビュー対象を入力してください'
      end
    end
  end

  describe '投稿の削除：DELETE /posts' do
    let!(:headers) { { HTTP_REFEREE: 'http://www.example.com/' } }
    context '削除できた時' do
      it 'リクエストが成功すること' do
        sign_in user
        delete post_path(@my_post.id)
        expect(response.status).to eq 302
      end
      it 'deleteが成功すること' do
        sign_in user
        expect do
          delete post_path(@my_post.id)
        end.to change(Post, :count).by(-1)
      end
      it '直前のパスにリダイレクトすること' do
        sign_in user
        delete post_path(@my_post.id), headers: headers
        expect(response).to redirect_to headers[:HTTP_REFEREE]
      end
    end

    context '削除に失敗した時' do
      it 'リクエストが成功すること' do
        sign_in user
        delete post_path(@my_post.id)
        delete post_path(@my_post.id)
        expect(response.status).to eq 302
      end
      it 'deleteが失敗すること' do
        sign_in user
        delete post_path(@my_post.id)
        expect do
          delete post_path(@my_post.id)
        end.not_to change(Post, :count)
      end
      it '削除に失敗した旨のメッセージが出ること' do
        sign_in user
        delete post_path(@my_post.id)
        delete post_path(@my_post.id)
        expect(response.request.flash.alert).to include '投稿が見つかりません'
      end
    end
  end

  describe 'トップ画面：GET /' do
    context 'ログイン済みの場合' do
      it 'リクエストが成功すること' do
        sign_in user
        get root_path
        expect(response.status).to eq 200
      end
      it 'タイムラインが表示されていること' do
        sign_in user
        get root_path
        expect(response.body).to include '私です'
        expect(response.body).to include 'another_user1です'
        expect(response.body).not_to include 'another_user2です'
      end
    end

    context '未ログインの場合' do
      it 'リクエストが成功すること' do
        get root_path
        expect(response.status).to eq 200
      end
      it 'みんなの投稿が表示されていること' do
        get root_path
        expect(response.body).to include '私です'
        expect(response.body).to include 'another_user1です'
        expect(response.body).to include 'another_user2です'
      end
    end
  end

  describe 'みんなの投稿画面：GET /posts/all' do
    context 'ログイン済みの場合' do
      it 'リクエストが成功すること' do
        sign_in user
        get all_posts_path
        expect(response.status).to eq 200
      end
      it 'みんなの投稿が表示されていること' do
        sign_in user
        get all_posts_path
        expect(response.body).to include '私です'
        expect(response.body).to include 'another_user1です'
        expect(response.body).to include 'another_user2です'
      end
    end

    context '未ログインの場合' do
      it 'リクエストが成功すること' do
        get all_posts_path
        expect(response.status).to eq 302
      end
      it 'ログインページにリダイレクトすること' do
        get all_posts_path
        expect(response).to redirect_to new_user_session_path
      end
      it 'ログインする必要がある旨のFlashメッセージが表示されること' do
        get all_posts_path
        expect(response.request.flash.alert).to include 'ログインまたは登録が必要です'
      end
    end
  end

  describe '人気の投稿画面：GET /posts/trend' do
    context 'ログイン済みの場合' do
      it 'リクエストが成功すること' do
        sign_in user
        get trend_posts_path
        expect(response.status).to eq 200
      end
      it '人気の投稿（お気に入り登録されている投稿）が表示されていること' do
        sign_in user
        post post_likes_path(@another_user2_post.id), xhr: true
        get trend_posts_path
        expect(response.body).not_to include '私です'
        expect(response.body).not_to include 'another_user1です'
        expect(response.body).to include 'another_user2です'
      end
    end

    context '未ログインの場合' do
      it 'リクエストが成功すること' do
        get trend_posts_path
        expect(response.status).to eq 200
      end
      it '人気の投稿（お気に入り登録されている投稿）が表示されていること' do
        sign_in user
        post post_likes_path(@another_user2_post.id), xhr: true
        get trend_posts_path
        expect(response.body).not_to include '私です'
        expect(response.body).not_to include 'another_user1です'
        expect(response.body).to include 'another_user2です'
      end
    end
  end
end
