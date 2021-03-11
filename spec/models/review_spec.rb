require 'rails_helper'

RSpec.describe Review, type: :model do
  before do
    @review = build(:review)
  end

  describe '基本の正常系' do
    it '正常系：タイトル、評価が有効（価格無し）' do
      expect(@review).to be_valid
    end
    it '正常系：タイトル、評価、価格が有効' do
      @review.price = 1800
      expect(@review).to be_valid
    end
  end

  describe '基本の異常系' do
    it '異常系：タイトルが入力されていないためエラー' do
      @review.title = nil
      expect(@review).to be_invalid
    end
    it '異常系：評価が入力されていないためエラー' do
      @review.rate = nil
      expect(@review).to be_invalid
    end
  end

  describe 'タイトル（title）のバリデーションチェック' do
    it '異常系：タイトル①　タイトルが51文字のためエラー' do
      @review.title = "あいうえおあいうえおかきくけこかきくけこさしすせそさしすせそたちつてとたちつてとなにぬねのなにぬねのは"
      @review.valid?
      expect(@review.errors[:title]).to include('は50文字以内で入力してください')
    end
    it '正常系：タイトル②　タイトルが50文字のため有効（境界値チェック）' do
      @review.title = "あいうえおあいうえおかきくけこかきくけこさしすせそさしすせそたちつてとたちつてとなにぬねのなにぬねの"
      expect(@review).to be_valid
    end
  end

  describe '価格（price）のバリデーションチェック' do
    it '異常系：価格①　価格が-1のためエラー' do
      @review.price = -1
      @review.valid?
      expect(@review.errors[:price]).to include('は0以上の値にしてください')
    end
    it '正常系：価格②　価格が0のため有効（境界値チェック）' do
      @review.price = 0
      expect(@review).to be_valid
    end
    it '異常系：価格③　価格が100,000,000のためエラー' do
      @review.price = 100000000
      @review.valid?
      expect(@review.errors[:price]).to include('は100000000より小さい値にしてください')
    end
    it '正常系：価格④　価格が99,999,999のため有効（境界値チェック）' do
      @review.price = 99999999
      expect(@review).to be_valid
    end
    it '異常系：価格⑤　価格が半角数字以外のためエラー' do
      prices = %w[１２３ いちにさん イチニサン 一二三 123# ott]
      prices.each do |invalid_price|
        @review.price = invalid_price
        @review.save
        @review.valid?
        expect(@review.errors[:price]).to include("は数値で入力してください")
      end
    end
  end
end
