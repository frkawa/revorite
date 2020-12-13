class Comment < ApplicationRecord
  validates :message, presence: true, unless: Proc.new {images.attached?}
  validate :message_length

  belongs_to :user
  belongs_to :post
  has_many_attached :images, dependent: :destroy

  def message_length
    if message.gsub(/\r\n/, 'A').length > 300
      errors.add(:message, "は300文字以下で入力してください")
    end
  end
end
