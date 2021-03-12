class Post < ApplicationRecord
  validates :text, presence: true, unless: Proc.new {images.attached?}
  validates :text, length: { maximum: 500 }
  include ImagesValidation

  belongs_to :user
  has_many_attached :images
  has_one :review, dependent: :destroy
  accepts_nested_attributes_for :review
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :reposts, dependent: :destroy

  attr_accessor :rev_flg

end
