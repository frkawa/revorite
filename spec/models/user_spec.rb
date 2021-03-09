require 'rails_helper'

RSpec.describe User, type: :model do
  describe '基本の正常系' do
    it '正常系：名前、メールアドレス、パスワード、パスワード（確認用）が全て有効' do
      user = build(:user)
      expect(user).to be_valid
    end
  end

  describe '名前（name）のバリデーションチェック' do
    it '異常系：名前①　名前が入力されていないため無効' do
      user = build(:user, name: nil)
      user.valid?
      expect(user.errors[:name]).to include('を入力してください')
    end
    it '異常系：名前②　名前が31文字のため無効' do
      user = build(:user, name: 'あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほま')
      user.valid?
      expect(user.errors[:name]).to include('は30文字以内で入力してください')
    end
    it '正常系：名前③　名前が30文字のため有効（境界値チェック）' do
      user = build(:user, name: 'あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほ')
      expect(user).to be_valid
    end
  end

  describe 'メールアドレス（email）のバリデーションチェック' do
    it '異常系：メールアドレス①　メールアドレスが入力されていないため無効' do
      user = build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include('を入力してください')
    end
    it '異常系：メールアドレス②　メールアドレスが256文字のため無効' do
      user = build(:user, email: 'aaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeoooo@example.com')
      user.valid?
      expect(user.errors[:email]).to include('は255文字以内で入力してください')
    end
    it '正常系：メールアドレス③　メールアドレスが255文字のため有効（境界値チェック）' do
      user = build(:user, email: 'aaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooo@example.com')
      expect(user).to be_valid
    end
    it '異常系：メールアドレス④　既に存在するメールアドレスのため無効' do
      user = create(:user)
      another_user = build(:user)
      another_user.valid?
      expect(another_user.errors[:email]).to include('はすでに存在します')
    end
    it '異常系：メールアドレス⑤　既に存在するメールアドレスのため無効（大文字と小文字の区別は付けない）' do
      user = create(:user)
      another_user = build(:user, email: 'TEST@EXAMPLE.COM')
      another_user.valid?
      expect(another_user.errors[:email]).to include('はすでに存在します')
    end
    it "異常系：メールアドレス⑥　メールアドレスのフォーマットが正しくないため無効" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. @bar_baz.com foo@bar+baz.com foo@bar..com]
      addresses.each do |invalid_address|
        expect(build(:user, email: invalid_address)).to be_invalid
      end
    end
  end
  
  describe 'パスワード（password）のバリデーションチェック' do
    it '異常系：パスワード①　パスワードが入力されていないため無効' do
      user = build(:user, password: nil)
      user.valid?
      expect(user.errors[:password]).to include('を入力してください')
    end
    it '異常系：パスワード②　パスワードが31文字のため無効' do
      user = build(:user, password: 'pass567890123456789012345678901', password_confirmation: 'pass567890123456789012345678901')
      user.valid?
      expect(user.errors[:password]).to include('は30文字以内で入力してください')
    end
    it '正常系：パスワード③　パスワードが30文字のため有効（境界値チェック）' do
      user = build(:user, password: 'pass56789012345678901234567890', password_confirmation: 'pass56789012345678901234567890')
      expect(user).to be_valid
    end
    it '異常系：パスワード④　パスワードが5文字のため無効' do
      user = build(:user, password: 'pass5', password_confirmation: 'pass5')
      user.valid?
      expect(user.errors[:password]).to include('は6文字以上で入力してください')
    end
    it '正常系：パスワード⑤　パスワードが6文字のため有効（境界値チェック）' do
      user = build(:user, password: 'pass56', password_confirmation: 'pass56')
      expect(user).to be_valid
    end
    it '異常系：パスワード⑥　パスワードのフォーマットが正しくないため無効' do
      passwords = %w[pass#01 pass@01 ｐａｓｓ01 pass０１ パス0101]
      passwords.each do |invalid_passwords|
        expect(build(:user, password: invalid_passwords)).to be_invalid
      end
    end
  end

  describe 'パスワード（確認用）（password_confirmation）のバリデーションチェック' do
    it '異常系：パスワード（確認用）①　パスワードと一致しない' do
      user = build(:user, password_confirmation: 'pass02')
      user.valid?
      expect(user.errors[:password_confirmation]).to include('とパスワードの入力が一致しません')
    end
  end
end
