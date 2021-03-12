require 'rails_helper'

RSpec.describe User, type: :model do
  describe '基本の正常系' do
    it '正常系：名前、メールアドレス、パスワード、パスワード（確認用）が全て有効' do
      user = build(:user)
      expect(user).to be_valid
    end
  end

  describe '名前（name）のバリデーションチェック' do
    it '異常系：名前①　名前が入力されていないためエラー' do
      user = build(:user, name: nil)
      user.valid?
      expect(user.errors[:name]).to include('を入力してください')
    end
    it '異常系：名前②　名前が31文字のためエラー' do
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
    it '異常系：メールアドレス①　メールアドレスが入力されていないためエラー' do
      user = build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include('を入力してください')
    end
    it '異常系：メールアドレス②　メールアドレスが256文字のためエラー' do
      user = build(:user, email: 'aaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeoooo@example.com')
      user.valid?
      expect(user.errors[:email]).to include('は255文字以内で入力してください')
    end
    it '正常系：メールアドレス③　メールアドレスが255文字のため有効（境界値チェック）' do
      user = build(:user, email: 'aaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooo@example.com')
      expect(user).to be_valid
    end
    it '異常系：メールアドレス④　既に存在するメールアドレスのためエラー' do
      user = create(:user)
      another_user = build(:user)
      another_user.valid?
      expect(another_user.errors[:email]).to include('はすでに存在します')
    end
    it '異常系：メールアドレス⑤　既に存在するメールアドレスのためエラー（大文字と小文字の区別は付けない）' do
      user = create(:user)
      another_user = build(:user, email: 'TEST@EXAMPLE.COM')
      another_user.valid?
      expect(another_user.errors[:email]).to include('はすでに存在します')
    end
    it "異常系：メールアドレス⑥　メールアドレスのフォーマットが正しくないためエラー" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. @bar_baz.com foo@bar+baz.com foo@bar..com]
      addresses.each do |invalid_address|
        expect(build(:user, email: invalid_address)).to be_invalid
      end
    end
  end
  
  describe 'パスワード（password）のバリデーションチェック' do
    it '異常系：パスワード①　パスワードが入力されていないためエラー' do
      user = build(:user, password: nil)
      user.valid?
      expect(user.errors[:password]).to include('を入力してください')
    end
    it '異常系：パスワード②　パスワードが31文字のためエラー' do
      user = build(:user, password: 'pass567890123456789012345678901', password_confirmation: 'pass567890123456789012345678901')
      user.valid?
      expect(user.errors[:password]).to include('は30文字以内で入力してください')
    end
    it '正常系：パスワード③　パスワードが30文字のため有効（境界値チェック）' do
      user = build(:user, password: 'pass56789012345678901234567890', password_confirmation: 'pass56789012345678901234567890')
      expect(user).to be_valid
    end
    it '異常系：パスワード④　パスワードが5文字のためエラー' do
      user = build(:user, password: 'pass5', password_confirmation: 'pass5')
      user.valid?
      expect(user.errors[:password]).to include('は6文字以上で入力してください')
    end
    it '正常系：パスワード⑤　パスワードが6文字のため有効（境界値チェック）' do
      user = build(:user, password: 'pass56', password_confirmation: 'pass56')
      expect(user).to be_valid
    end
    it '異常系：パスワード⑥　パスワードのフォーマットが正しくないためエラー' do
      passwords = %w[pass#01 pass@01 ｐａｓｓ01 pass０１ パス0101]
      passwords.each do |invalid_passwords|
        expect(build(:user, password: invalid_passwords)).to be_invalid
      end
    end
  end

  describe 'パスワード（確認用）（password_confirmation）のバリデーションチェック' do
    it '異常系：パスワード（確認用）①　パスワードと一致しないためエラー' do
      user = build(:user, password_confirmation: 'pass02')
      user.valid?
      expect(user.errors[:password_confirmation]).to include('とパスワードの入力が一致しません')
    end
  end

  describe '自己紹介（description）のバリデーションチェック' do
    it '異常系：自己紹介①　自己紹介が151文字のためエラー' do
      user = build(:user, description: 'aaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooa')
      user.valid?
      expect(user.errors[:description]).to include('は150文字以内で入力してください')
    end
    it '正常系：自己紹介③　自己紹介が150文字のため有効（境界値チェック）' do
      user = build(:user, description: 'aaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeoooooooooo')
      expect(user).to be_valid
    end
  end

  describe 'アイコン画像（image）のバリデーションチェック' do
    before do
      @user = build(:user)
    end
    it '異常系：アイコン画像①　JPEG、PNG以外の形式でアップロードしているためエラー' do
      @user.image = fixture_file_upload('/files/partyparrot.gif')
      @user.valid?
      expect(@user.errors[:image]).to include("はjpegまたはpng形式でアップロードしてください")
    end
    it '異常系：アイコン画像②　ファイルが3MBを超えているためエラー' do
      @user.image = fixture_file_upload('/files/large.png')
      @user.valid?
      expect(@user.errors[:image]).to include("は3MB以内にしてください")
    end
    it '正常系：アイコン画像③　JPEG、PNGの形式で3MB未満に収めてアップロードしているため有効' do
      @user.image = fixture_file_upload('/files/1.png')
      expect(@user).to be_valid
    end
  end

  describe 'アソシエーションの確認' do
    it 'userを削除すると、そのuserの投稿（posts）も削除される' do
      post = create(:post)
      expect{ post.user.destroy }.to change{ Post.count }.by(-1)
    end
    it 'userを削除すると、そのuserのお気に入り（likes）も削除される' do
      like = create(:like)
      expect{ like.post.user.destroy }.to change{ Like.count }.by(-1)
    end
    it 'userを削除すると、そのuserのコメント（comment）も削除される' do
      comment = create(:comment)
      expect{ comment.post.user.destroy }.to change{ Comment.count }.by(-1)
    end
    it 'userを削除すると、そのuserのレビュー（review）も削除される' do
      review = create(:review)
      expect{ review.post.user.destroy }.to change{ Review.count }.by(-1)
    end
    it 'userを削除すると、そのuserのリポスト（repost）も削除される' do
      repost = create(:repost)
      expect{ repost.post.user.destroy }.to change{ Repost.count }.by(-1)
    end
    it 'お気に入り登録すると、like_postsが1件増える' do
      like = build(:like)
      expect{ like.save }.to change{ like.post.user.like_posts.count }.by(+1)
    end
    it 'リポストすると、reposted_postsが1件増える' do
      repost = build(:repost)
      expect{ repost.save }.to change{ repost.post.user.reposted_posts.count }.by(+1)
    end
    it 'userを削除すると、そのuserのrelationshipも削除される' do
      user = create(:user)
      another_user = create(:user, email: 'another@example.com')
      relationship = create(:relationship, user_id: user.id, follow_id: another_user.id)
      expect{ user.destroy }.to change{ Relationship.count }.by(-1)
    end

    describe 'フォロー・フォロワーの確認' do
      before do
        @user = create(:user)
        @another_user = create(:user, email: 'another@example.com')
        @relationship = build(:relationship, user_id: @user.id, follow_id: @another_user.id)
      end
      context 'userがanother_userをフォローした場合' do
        it 'userのfollowingsが1件増える' do
          expect{ @relationship.save }.to change{ @user.followings.count }.by(+1)
        end
        it 'another_userのfollowersが1件増える' do
          expect{ @relationship.save }.to change{ @another_user.followers.count }.by(+1)
        end
      end
      context 'userがanother_userをフォローした状態でanother_userを削除した場合' do
        it 'userのfollowingsが1件減る' do
          @relationship.save
          expect{ @another_user.destroy }.to change{ @user.followings.count }.by(-1)
        end
      end
      context 'userがanother_userをフォローした状態でuserを削除した場合' do
        it 'another_userのfollowersが1件減る' do
          @relationship.save
          expect{ @user.destroy }.to change{ @another_user.followers.count }.by(-1)
        end
      end
    end
  end

  describe 'クラスメソッドの確認' do
    describe 'User.guestの確認' do
      before do
        @guest = User.find_by(email: 'guest@guest.com')
      end
      context 'ゲストアカウントが無い場合' do
        it 'ゲストアカウントを作成し、アカウント情報を取得する' do
          if @guest
            @guest.destroy
          end
          new_guest = User.guest
          expect(new_guest.email).to eq 'guest@guest.com'
        end
      end
      context 'ゲストアカウントがある場合' do
        it '既存のアカウント情報を取得する' do
          @guest = User.find_by(email: 'guest@guest.com')
          unless @guest
            User.guest
          end
          new_guest = User.guest
          expect(new_guest.email).to eq 'guest@guest.com'
        end
      end
    end

    describe 'User.followings_with_userselfの確認' do
      context 'userがanother_userをフォローしている場合' do
        it 'user.followings_with_userselfは2件となる' do
          user = create(:user)
          another_user = create(:user, email: 'another@example.com')
          relationship = create(:relationship, user_id: user.id, follow_id: another_user.id)
          expect(user.followings_with_userself.count).to eq 2
        end
      end
    end

    describe 'User.posts_with_repostsの確認' do
      context 'userがポストAを投稿→another_userがポストBを投稿→userがポストCを投稿→userがポストBをリポスト。という時系列の場合' do
        it 'user.posts_with_repostsでB→C→Aの順で3件取得する' do
          user = create(:user)
          another_user = create(:user, email: 'another@example.com')
          post_a = Post.create(user_id: user.id, text: 'ポストA')
          sleep(1)
          post_b = Post.create(user_id: another_user.id, text: 'ポストB')
          sleep(1)
          post_c = Post.create(user_id: user.id, text: 'ポストC')
          sleep(1)
          Repost.create(user_id: user.id, post_id: post_b.id)
          expect(user.posts_with_reposts.size).to eq 3
          expect(user.posts_with_reposts.pluck(:text)).to eq ["ポストB", "ポストC", "ポストA"]
        end
      end
    end

    describe 'User.followings_posts_with_repostsの確認' do
      context 'user_aがuser_b,user_cをフォロー。A1（user_a）→B1（user_b）→D1（user_d）→D2（user_d）→B1（user_cのリポスト）→D2（user_bのリポスト）→D1（user_cのリポスト）→D1（user_aのリポスト）という時系列の場合' do
        it 'user.followings_posts_with_repostsでD1→D2→B1→A1の順で4件取得する' do
          user_a = create(:user)
          user_b = create(:user, email: 'user_b@example.com')
          user_c = create(:user, email: 'user_c@example.com')
          user_d = create(:user, email: 'user_d@example.com')
          create(:relationship, user_id: user_a.id, follow_id: user_b.id)
          create(:relationship, user_id: user_a.id, follow_id: user_c.id)
          post_A1 = Post.create(user_id: user_a.id, text: 'ポストA1')
          sleep(1)
          post_B1 = Post.create(user_id: user_b.id, text: 'ポストB1')
          sleep(1)
          post_D1 = Post.create(user_id: user_d.id, text: 'ポストD1')
          sleep(1)
          post_D2 = Post.create(user_id: user_d.id, text: 'ポストD2')
          sleep(1)
          Repost.create(user_id: user_c.id, post_id: post_B1.id)
          sleep(1)
          Repost.create(user_id: user_b.id, post_id: post_D2.id)
          sleep(1)
          Repost.create(user_id: user_c.id, post_id: post_D1.id)
          sleep(1)
          Repost.create(user_id: user_a.id, post_id: post_D1.id)
          expect(user_a.followings_posts_with_reposts.size).to eq 4
          expect(user_a.followings_posts_with_reposts.pluck(:text)).to eq ["ポストD1", "ポストD2", "ポストB1", "ポストA1",]
        end
      end
    end

    describe 'User.reposted?(post_id)の確認' do
      context 'リポスト済みの場合' do
        it 'trueを返す' do
          repost = create(:repost)
          expect(repost.post.user.reposted?(repost.post.id)).to be_truthy
        end
      end
      context 'リポストしていない場合' do
        it 'falseを返す' do
          post = create(:post)
          expect(post.user.reposted?(post.id)).to be_falsy
        end
      end
    end

    describe 'User.likeed?(post_id)の確認' do
      context 'お気に入り済みの場合' do
        it 'trueを返す' do
          like = create(:like)
          expect(like.post.user.liked?(like.post.id)).to be_truthy
        end
      end
      context 'お気に入りしていない場合' do
        it 'falseを返す' do
          post = create(:post)
          expect(post.user.liked?(post.id)).to be_falsy
        end
      end
    end

    describe 'User.follow(other_user)の確認' do
      before do
        @user = create(:user)
        @another_user = create(:user, email: 'another_user@example.com')
      end
      context 'フォロー先が自分自身の場合' do
        it 'フォローしない（何も起こらない）' do
          expect{ @user.follow(@user) }.to change{ @user.followings.count }.by(0)
        end
      end
      context 'フォロー先が他人、かつ未フォローの場合' do
        it 'フォローする' do
          expect{ @user.follow(@another_user) }.to change{ @user.followings.count }.by(+1)
        end
      end
      context 'フォロー先が他人、かつフォロー済みの場合' do
        it 'フォローしない（何も起こらない）' do
          Relationship.create(user_id: @user.id, follow_id: @another_user.id)
          expect{ @user.follow(@another_user) }.to change{ @user.followings.count }.by(0)
        end
      end
    end

    describe 'User.unfollow(other_user)の確認' do
      before do
        @user = create(:user)
        @another_user = create(:user, email: 'another_user@example.com')
      end
      context 'フォローしている場合' do
        it 'フォローを解除する' do
          Relationship.create(user_id: @user.id, follow_id: @another_user.id)
          expect{ @user.unfollow(@another_user) }.to change{ @user.followings.count }.by(-1)
        end
      end
      context 'フォローしていない場合' do
        it '何も起こらない' do
          expect{ @user.unfollow(@another_user) }.to change{ @user.followings.count }.by(0)
        end
      end
    end

    describe 'User.following?(other_user)の確認' do
      before do
        @user = create(:user)
        @another_user = create(:user, email: 'another_user@example.com')
      end
      context 'フォローしている場合' do
        it 'Trueを返す' do
          Relationship.create(user_id: @user.id, follow_id: @another_user.id)
          expect(@user.following?(@another_user)).to be_truthy
        end
      end
      context 'フォローしていない場合' do
        it '何も起こらない' do
          expect(@user.following?(@another_user)).to be_falsy
        end
      end
    end
  end
end
