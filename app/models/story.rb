class Story < ApplicationRecord
  include Publishable

  validates :title, presence: true
  validates :content, presence: true
  validates :status, presence: true

  has_one_attached :header_image

  # Image validations
  validates :header_image,
            content_type: {
              in: ['image/png', 'image/jpeg', 'image/gif', 'image/webp'],
              message: 'must be a PNG, JPG, GIF, or WebP image'
            },
            size: {
              less_than: 10.megabytes,
              message: 'must be less than 10MB'
            }
end
