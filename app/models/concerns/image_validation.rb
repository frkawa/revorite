module ImageValidation
  extend ActiveSupport::Concern

  included do
    validate :image_length, :image_type, :image_size

    def image_length
      if images.length > 4
        images.purge
        errors.add(:images, "は一度に4枚まで投稿可能です。")
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
          errors.add(:images, "は1ファイルにつき3MB以内にしてください")
        end
      end
    end
    
  end
end