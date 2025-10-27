# Posts and Stories may have a status of draft, published, or archived.
# They also share common image attachment behavior.
module Publishable
  extend ActiveSupport::Concern

  included do
    # Status enum for content lifecycle
    enum :status, {
      draft: 'draft',
      published: 'published',
      archived: 'archived'
    }

    # Shared header image attachment
    has_one_attached :header_image

    # Image validations
    validates :header_image,
              content_type: {
                in: ['image/png', 'image/jpeg', 'image/gif', 'image/webp'],
                message: 'must be a PNG, JPG, GIF, or WebP image'
              },
              size: {
                less_than: 5.megabytes,
                message: 'must be less than 5MB'
              }
  end
end
