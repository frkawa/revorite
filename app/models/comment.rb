class Comment < ApplicationRecord
  validates :message, presence: true, unless: Proc.new {images.attached?}
  validates :message, length: { maximum: 300 }
  include ImageValidation

  belongs_to :user
  belongs_to :post
  has_many_attached :images, dependent: :destroy
end
