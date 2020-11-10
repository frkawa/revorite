class Post < ApplicationRecord
  validates :text, presence: true, length: { maximum: 500 }

  belongs_to :user
end
