require 'rails_helper'

RSpec.describe Comment, type: :model do
  before do
    @comment = build(:comment)
  end

  describe '基本の正常系' do
    it '正常系：本文が有効（画像無し）' do
      expect(@comment).to be_valid
    end
    it '正常系：画像が有効（本文無し）' do
      @comment.message = nil
      @comment.images = fixture_file_upload('/files/1.png')
      expect(@comment).to be_valid
    end
    it '正常系：本文、画像が有効' do
      @comment.images = fixture_file_upload('/files/1.png')
      expect(@comment).to be_valid
    end
  end

  describe '基本の異常系' do
    it '異常系：本文・画像①　本文と画像どちらも入力されていないためエラー' do
      @comment.message = nil
      @comment.valid?
      expect(@comment.errors[:message]).to include('を入力してください')
    end
  end

  describe '本文（message）のバリデーションチェック' do
    it '異常系：本文①　本文が301文字のためエラー' do
      @comment.message = "aaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooa"
      @comment.valid?
      expect(@comment.errors[:message]).to include('は300文字以内で入力してください')
    end
    it '正常系：本文②　本文が300文字のため有効（境界値チェック）' do
      @comment.message = "aaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeooooooooooaaaaaaaaaaiiiiiiiiiiuuuuuuuuuueeeeeeeeeeoooooooooo"
      expect(@comment).to be_valid
    end
  end

  describe '画像（images）のバリデーションチェック' do
    it '異常系：画像①　画像を5枚投稿しているためエラー' do
      @comment.images = fixture_file_upload('/files/1.png')
      @comment.images = fixture_file_upload('/files/2.jpg')
      @comment.images = fixture_file_upload('/files/3.jpg')
      @comment.images = fixture_file_upload('/files/4.jpeg')
      @comment.images = fixture_file_upload('/files/5.jpg')
      @comment.valid?
      expect(@comment.errors[:images]).to include("は一度に4枚まで投稿可能です")
    end
    it '異常系：画像②　JPEG、PNG以外の形式で投稿しているためエラー' do
      @comment.images = fixture_file_upload('/files/partyparrot.gif')
      @comment.valid?
      expect(@comment.errors[:images]).to include("はjpegまたはpng形式でアップロードしてください")
    end
    it '異常系：画像③　1ファイルにつき3MBを超えているためエラー' do
      @comment.images = fixture_file_upload('/files/large.png')
      @comment.valid?
      expect(@comment.errors[:images]).to include("は1ファイルにつき3MB以内にしてください")
    end
    it '正常系：画像④　JPEG、PNGの形式で4枚投稿、1枚当たり3MB未満に収めて投稿しているため有効' do
      @comment.images = fixture_file_upload('/files/1.png')
      @comment.images = fixture_file_upload('/files/2.jpg')
      @comment.images = fixture_file_upload('/files/3.jpg')
      @comment.images = fixture_file_upload('/files/4.jpeg')
      expect(@comment).to be_valid
    end
  end
end