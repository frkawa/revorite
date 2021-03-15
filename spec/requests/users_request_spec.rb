require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { create(:user) }
  let(:user_params) { attributes_for(:user) }
  let(:invalid_user_params) { attributes_for(:user, name: "") }

  describe '新規登録：POST /users/sign_up' do
    context '有効なパラメータの場合' do
      it 'リクエストが成功すること' do
        post user_registration_path, params: { user: user_params }
        expect(response.status).to eq 302
      end
      it 'createが成功すること' do
        expect do
          post user_registration_path, params: { user: user_params }
        end.to change(User, :count).by(+1)
      end
      it 'ルートにリダイレクトすること' do
        post user_registration_path, params: { user: user_params }
        expect(response).to redirect_to root_path
      end
      it 'Flashメッセージが表示されること' do
        post user_registration_path, params: { user: user_params }
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
end
