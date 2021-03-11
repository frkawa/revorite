require 'rails_helper'

RSpec.describe Post, type: :model do
  before do
    @post = build(:post)
  end

  describe '基本の正常系' do
    it '正常系：本文が有効（画像無し）' do
      expect(@post).to be_valid
    end
    it '正常系：画像が有効（本文無し）' do
      @post.text = nil
      @post.images = fixture_file_upload('/files/1.png')
      expect(@post).to be_valid
    end
    it '正常系：本文、画像が有効' do
      @post.images = fixture_file_upload('/files/1.png')
      expect(@post).to be_valid
    end
  end

  describe '基本の異常系' do
    it '異常系：本文・画像①　本文と画像どちらも入力されていないためエラー' do
      @post.text = nil
      expect(@post).to be_invalid
    end
  end

  describe '本文（text）のバリデーションチェック' do
    it '異常系：本文①　本文が501文字のためエラー' do
      @post.text = "aaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooa"
      @post.valid?
      expect(@post.errors[:text]).to include('は500文字以内で入力してください')
    end
    it '正常系：本文②　本文が500文字のため有効（境界値チェック）' do
      @post.text = "aaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeoooooooooo"
      expect(@post).to be_valid
    end
  end

  describe '画像（images）のバリデーションチェック' do
    it '異常系：画像①　画像を5枚投稿しているためエラー' do
      @post.images = fixture_file_upload('/files/1.png')
      @post.images = fixture_file_upload('/files/2.jpg')
      @post.images = fixture_file_upload('/files/3.jpg')
      @post.images = fixture_file_upload('/files/4.jpeg')
      @post.images = fixture_file_upload('/files/5.jpg')
      @post.valid?
      expect(@post.errors[:images]).to include("は一度に4枚まで投稿可能です")
    end
    it '異常系：画像②　JPEG、PNG以外の形式で投稿しているためエラー' do
      @post.images = fixture_file_upload('/files/partyparrot.gif')
      @post.valid?
      expect(@post.errors[:images]).to include("はjpegまたはpng形式でアップロードしてください")
    end
    it '異常系：画像③　1ファイルにつき3MBを超えているためエラー' do
      @post.images = fixture_file_upload('/files/large.png')
      @post.valid?
      expect(@post.errors[:images]).to include("は1ファイルにつき3MB以内にしてください")
    end
    it '正常系：画像④　JPEG、PNGの形式で4枚投稿、1枚当たり3MB未満に収めて投稿しているため有効' do
      @post.images = fixture_file_upload('/files/1.png')
      @post.images = fixture_file_upload('/files/2.jpg')
      @post.images = fixture_file_upload('/files/3.jpg')
      @post.images = fixture_file_upload('/files/4.jpeg')
      expect(@post).to be_valid
    end
  end

  describe 'アソシエーションの確認' do
    it 'postを削除すると、そのpostのレビュー（review）も削除される' do
      review = create(:review)
      expect{ review.post.destroy }.to change{ Review.count }.by(-1)
    end
    it 'postを削除すると、そのpostのお気に入り（likes）も削除される' do
      like = create(:like)
      expect{ like.post.destroy }.to change{ Like.count }.by(-1)
    end
    it 'postを削除すると、そのpostのコメント（comment）も削除される' do
      comment = create(:comment)
      expect{ comment.post.destroy }.to change{ Comment.count }.by(-1)
    end
    it 'postを削除すると、そのpostのリポスト（repost）も削除される' do
      repost = create(:repost)
      expect{ repost.post.destroy }.to change{ Repost.count }.by(-1)
    end
  end
end