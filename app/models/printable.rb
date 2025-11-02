class Printable < ApplicationRecord
  include Publishable

  validates :title, presence: true
  validates :status, presence: true

  has_one_attached :pdf_file
  has_one_attached :image_file # For single-page printables (alternative to PDF)
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

  # PDF file validations (only if attached - allows creating without file)
  validates :pdf_file,
            content_type: {
              in: ['application/pdf'],
              message: 'must be a PDF file'
            },
            size: {
              less_than: 15.megabytes,
              message: 'must be less than 15MB'
            },
            if: -> { pdf_file.attached? }

  # Image file validations (only if attached - allows creating without file)
  validates :image_file,
            content_type: {
              in: ['image/png', 'image/jpeg', 'image/gif', 'image/webp'],
              message: 'must be a PNG, JPG, GIF, or WebP image'
            },
            size: {
              less_than: 10.megabytes,
              message: 'must be less than 10MB'
            },
            if: -> { image_file.attached? }

  # Thumbnail image validations (only if attached - allows creating without file)
  validates :thumbnail_image,
            content_type: {
              in: ['image/png', 'image/jpeg', 'image/gif', 'image/webp'],
              message: 'must be a PNG, JPG, GIF, or WebP image'
            },
            size: {
              less_than: 1.megabyte,
              message: 'must be less than 1MB'
            },
            if: -> { thumbnail_image.attached? }

  # Helper method to get the main file (PDF or image)
  def main_file
    pdf_file.attached? ? pdf_file : image_file
  end

  # Helper method to check if printable has a main file
  def has_main_file?
    pdf_file.attached? || image_file.attached?
  end

  # Get thumbnail image, falling back to image_file if no thumbnail is attached
  # This allows using the same image for both printable and thumbnail
  def display_thumbnail
    return thumbnail_image if thumbnail_image.attached?
    return image_file if image_file.attached?

    nil
  end

  # Check if we're using the same image for thumbnail and printable
  def using_same_image_for_thumbnail?
    image_file.attached? && !thumbnail_image.attached?
  end
end
