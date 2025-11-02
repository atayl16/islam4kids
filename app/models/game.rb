class Game < ApplicationRecord
  include Publishable

  validates :title, presence: true
  validates :game_url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: 'must be a valid URL' }
  validates :status, presence: true

  has_one_attached :thumbnail_image

  validates :thumbnail_image,
            content_type: {
              in: ['image/png', 'image/jpeg', 'image/gif', 'image/webp'],
              message: 'must be a PNG, JPG, GIF, or WebP image'
            },
            size: {
              less_than: 10.megabytes,
              message: 'must be less than 10MB'
            },
            if: -> { thumbnail_image.attached? }
end
