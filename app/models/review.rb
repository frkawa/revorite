class Review < ApplicationRecord
  validates :title, length: { maximum: 50 }

  belongs_to :post
end
