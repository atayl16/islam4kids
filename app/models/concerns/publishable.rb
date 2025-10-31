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

    # Cache invalidation callbacks
    after_commit :clear_cache
  end

  private

  def clear_cache
    model_name = self.class.name.downcase.pluralize
    Rails.cache.delete("#{model_name}/published-collection")
    Rails.cache.delete("#{model_name}/#{id}")
  end
end
