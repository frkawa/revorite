require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { create(:user) }
  let(:user_params) { attributes_for(:user) }
  let(:invalid_user_params) { attributes_for(:user, name: "") }
  before do
    @another_user1 = create(:another_user, description: 'another_user1の自己紹介')
    @another_user2 = create(:another_user, description: 'another_user2の自己紹介', email: "test03@example.com")
    @another_user1_post = Post.create(text: 'another_user1です', user_id: @another_user1.id)
    @my_post = Post.create(text: '私です', user_id: user.id)
    user.follow(@another_user1)
    @another_user2.follow(user)
  end

  describe '新規登録：POST /users/sign_up' do
    context '有効なパラメータの場合' do
      it 'リクエストが成功すること' do
        post user_registration_path, params: { user: { name: 'new', email: 'new-user@example.com', password: 'pass01', password_confirmation: 'pass01' } }
        expect(response.status).to eq 302
      end
      it 'createが成功すること' do
        expect do
          post user_registration_path, params: { user: { name: 'new', email: 'new-user@example.com', password: 'pass01', password_confirmation: 'pass01' } }
        end.to change(User, :count).by(+1)
      end
      it 'ルートにリダイレクトすること' do
        post user_registration_path, params: { user: { name: 'new', email: 'new-user@example.com', password: 'pass01', password_confirmation: 'pass01' } }
        expect(response).to redirect_to root_path
      end
      it 'Flashメッセージが表示されること' do
        post user_registration_path, params: { user: { name: 'new', email: 'new-user@example.com', password: 'pass01', password_confirmation: 'pass01' } }
        expect(response.request.flash.notice).to include 'ようこそ！アカウントが登録されました'
      end
    end

    context '無効なパラメータの場合' do
      it 'リクエストが成功すること' do
        post user_registration_path, params: { user: invalid_user_params }
        expect(response.status).to eq 200
      end
      it 'createが失敗すること' do
        expect do
          post user_registration_path, params: { user: invalid_user_params }
        end.not_to change(User, :count)
      end
      it 'エラーが表示されること' do
        post user_registration_path, params: { user: invalid_user_params }
        expect(response.body).to include '名前を入力してください'
      end
    end
  end

  describe 'ログイン：POST /users/sign_in' do
    context '有効なパラメータの場合' do
      it 'リクエストが成功すること' do
        post user_session_path, params: { user: { email: user.email, password: user.password } }
        expect(response.status).to eq 302
      end
      it 'ルートにリダイレクトすること' do
        post user_session_path, params: { user: { email: user.email, password: user.password } }
        expect(response).to redirect_to root_path
      end
      it 'ログインした旨のflashメッセージが表示されること' do
        post user_session_path, params: { user: { email: user.email, password: user.password } }
        expect(response.request.flash.notice).to include 'ログインしました'
      end
    end

    context '無効なパラメータの場合' do
      it 'リクエストが成功すること' do
        post user_session_path, params: { user: { email: user.email, password: "incorrect" } }
        expect(response.status).to eq 200
      end
      it 'ルートにリダイレクトしないこと' do
        post user_session_path, params: { user: { email: user.email, password: "incorrect" } }
        expect(response).not_to redirect_to root_path
      end
      it 'ログインできない旨のflashメッセージが表示されること' do
        post user_session_path, params: { user: { email: user.email, password: "incorrect" } }
        expect(response.request.flash.alert).to include 'メールアドレスまたはパスワードが違います'
      end
    end
  end

  describe 'かんたんログイン：POST /users/guest_sign_in' do
    it 'リクエストが成功すること' do
      post users_guest_sign_in_path
      expect(response.status).to eq 302
    end
    it 'ルートにリダイレクトすること' do
      post users_guest_sign_in_path
      expect(response).to redirect_to root_path
    end
    it 'ログインした旨のflashメッセージが表示されること' do
      post users_guest_sign_in_path
      expect(response.request.flash.notice).to include 'ログインしました'
    end
  end

  describe 'プロフィール変更：PATCH /users/edit' do
    context '有効なパラメータの場合' do
      it 'リクエストが成功すること' do
        sign_in user
        patch user_registration_path, params: { user: { description: "I am TOM." } }
        expect(response.status).to eq 302
      end
      it 'マイページにリダイレクトすること' do
        sign_in user
        patch user_registration_path, params: { user: { description: "I am TOM." } }
        expect(response).to redirect_to user_path(user.id)
      end
      it 'プロフィールを更新した旨のflashメッセージが表示されること' do
        sign_in user
        patch user_registration_path, params: { user: { description: "I am TOM." } }
        expect(response.request.flash.notice).to include 'プロフィールが更新されました'
      end
    end

    context '無効なパラメータの場合' do
      it 'リクエストが成功すること' do
        sign_in user
        patch user_registration_path, params: { user: { description: "AAAAAIIIIIUUUUUEEEEEOOOOOAAAAAIIIIIUUUUUEEEEEOOOOOAAAAAIIIIIUUUUUEEEEEOOOOOAAAAAIIIIIUUUUUEEEEEOOOOOAAAAAIIIIIUUUUUEEEEEOOOOOAAAAAIIIIIUUUUUEEEEEOOOOOA" } }
        expect(response.status).to eq 200
      end
      it 'マイページにリダイレクトしないこと' do
        sign_in user
        patch user_registration_path, params: { user: { description: "AAAAAIIIIIUUUUUEEEEEOOOOOAAAAAIIIIIUUUUUEEEEEOOOOOAAAAAIIIIIUUUUUEEEEEOOOOOAAAAAIIIIIUUUUUEEEEEOOOOOAAAAAIIIIIUUUUUEEEEEOOOOOAAAAAIIIIIUUUUUEEEEEOOOOOA" } }
        expect(response).not_to redirect_to user_path(user.id)
      end
      it 'エラーが表示されること' do
        sign_in user
        patch user_registration_path, params: { user: { description: "AAAAAIIIIIUUUUUEEEEEOOOOOAAAAAIIIIIUUUUUEEEEEOOOOOAAAAAIIIIIUUUUUEEEEEOOOOOAAAAAIIIIIUUUUUEEEEEOOOOOAAAAAIIIIIUUUUUEEEEEOOOOOAAAAAIIIIIUUUUUEEEEEOOOOOA" } }
        expect(response.body).to include '自己紹介は150文字以内で入力してください'
      end
    end
  end

  describe 'ログアウト：DELETE /users/sign_out' do
    it 'リクエストが成功すること' do
      sign_in user
      delete destroy_user_session_path
      expect(response.status).to eq 302
    end
    it 'ログインページにリダイレクトすること' do
      sign_in user
      delete destroy_user_session_path
      expect(response).to redirect_to user_session_path
    end
    it 'ログインした旨のflashメッセージが表示されること' do
      sign_in user
      delete destroy_user_session_path
      expect(response.request.flash.notice).to include 'ログアウトしました'
    end
  end

  describe 'アカウント削除：DELETE /users/registration' do
    it 'リクエストが成功すること' do
      sign_in user
      delete user_registration_path
      expect(response.status).to eq 302
    end
    it 'ログインページにリダイレクトすること' do
      sign_in user
      delete user_registration_path
      expect(response).to redirect_to user_session_path
    end
    it 'アカウントを削除した旨のflashメッセージが表示されること' do
      sign_in user
      delete user_registration_path
      expect(response.request.flash.notice).to include 'アカウントが削除されました。またのご利用をお待ちしています'
    end
  end

  describe 'ユーザ情報ページ（投稿一覧）：GET /users/user.id' do
    it 'リクエストが成功すること' do
      get user_path(user.id)
      expect(response.status).to eq 200
    end
    it 'ユーザの投稿一覧が表示されていること' do
      get user_path(user.id)
      expect(response.body).to include '私です'
      expect(response.body).not_to include 'another_user1です'
      expect(response.body).not_to include 'another_user2です'
    end
  end

  describe 'ユーザ情報ページ（お気に入り一覧）：GET /users/user.id/likes' do
    it 'リクエストが成功すること' do
      sign_in user
      post post_likes_path(@another_user1_post.id), xhr: true
      get likes_user_path(user.id)
      expect(response.status).to eq 200
    end
    it 'ユーザのお気に入り一覧が表示されていること' do
      sign_in user
      post post_likes_path(@another_user1_post.id), xhr: true
      get likes_user_path(user.id)
      expect(response.body).not_to include '私です'
      expect(response.body).to include 'another_user1です'
      expect(response.body).not_to include 'another_user2です'
    end
  end

  describe 'ユーザ情報ページ（フォロー一覧）：GET /users/user.id/followings' do
    it 'リクエストが成功すること' do
      get followings_user_path(user.id)
      expect(response.status).to eq 200
    end
    it 'ユーザのフォロー一覧が表示されていること' do
      get followings_user_path(user.id)
      expect(response.body).to include 'another_user1の自己紹介'
      expect(response.body).not_to include 'another_user2の自己紹介'
    end
  end

  describe 'ユーザ情報ページ（フォロワー一覧）：GET /users/user.id/followers' do
    it 'リクエストが成功すること' do
      get followers_user_path(user.id)
      expect(response.status).to eq 200
    end
    it 'ユーザのフォロワー一覧が表示されていること' do
      get followers_user_path(user.id)
      expect(response.body).not_to include 'another_user1の自己紹介'
      expect(response.body).to include 'another_user2の自己紹介'
    end
  end
end
