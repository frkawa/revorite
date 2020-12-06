class Post < ApplicationRecord
  validates :text, presence: true, unless: Proc.new {images.attached?}
  validates :text, length: { maximum: 500 }
  validate :image_length, :image_type, :image_size

  belongs_to :user
  has_many_attached :images, dependent: :destroy
  has_one :review, dependent: :destroy
  accepts_nested_attributes_for :review
  has_many :likes, dependent: :destroy

  attr_accessor :rev_flg

  def image_length
    if images.length > 4
      images.purge
      errors.add(:images, "は4枚まで同時投稿が可能です。")
    end
  end

  def image_type
    images.each do |image|
      if !image.blob.content_type.in?(%('image/jpeg image/png'))
        images.purge
        errors.add(:images, 'はjpegまたはpng形式でアップロードしてください')
      end
    end
  end

  def image_size
    images.each do |image|
      if image.blob.byte_size > 3.megabytes
        image.purge
        errors.add(:images, "は1つのファイル3MB以内にしてください")
      end
    end
  end

end
