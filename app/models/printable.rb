class Printable < ApplicationRecord
  include Publishable

  validates :title, presence: true
  validates :status, presence: true

  has_one_attached :pdf_file
  has_one_attached :thumbnail_image

  enum :printable_type, {
    ebook: 'ebook',
    worksheet: 'worksheet',
    activity: 'activity',
    journal: 'journal',
    flashcard: 'flashcard',
    poster: 'poster',
    certificate: 'certificate',
    tracker: 'tracker',
    planner: 'planner'
  }

  # PDF file validations
  validates :pdf_file,
            attached: true,
            content_type: {
              in: ['application/pdf'],
              message: 'must be a PDF file'
            },
            size: {
              less_than: 10.megabytes,
              message: 'must be less than 10MB'
            }

  # Thumbnail image validations
  validates :thumbnail_image,
            attached: true,
            content_type: {
              in: ['image/png', 'image/jpeg', 'image/gif', 'image/webp'],
              message: 'must be a PNG, JPG, GIF, or WebP image'
            },
            size: {
              less_than: 1.megabyte,
              message: 'must be less than 1MB'
            }
end
