# Posts and Stories may have a status of draft, published, or archived.
module Publishable
  extend ActiveSupport::Concern

  included do
    enum :status, {
      draft: 'draft',
      published: 'published',
      archived: 'archived'
    }
  end
end
