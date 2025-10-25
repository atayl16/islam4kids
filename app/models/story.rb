class Story < ApplicationRecord
  include Publishable

  validates :title, presence: true
  validates :content, presence: true
  validates :status, presence: true
end
