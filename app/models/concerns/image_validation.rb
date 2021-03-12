module ImageValidation
  extend ActiveSupport::Concern

  included do
    validate :image_type, :image_size

    def image_type
      return unless image.attached?
      if !image.blob.content_type.in?(%('image/jpeg image/png'))
        image.purge
        errors.add(:image, 'はjpegまたはpng形式でアップロードしてください')
      end
    end

    def image_size
      return unless image.attached?
      if image.blob.byte_size > 3.megabytes
        image.purge
        errors.add(:image, "は3MB以内にしてください")
      end
    end
  end
end