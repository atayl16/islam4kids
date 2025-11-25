class Video < ApplicationRecord
  include Publishable

  validates :title, presence: true
  validates :video_url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: 'must be a valid URL' }
  validates :status, presence: true

  scope :featured, -> { where(featured: true) }
  scope :ordered, -> { order(position: :asc, created_at: :desc) }

  # Extract YouTube video ID from various URL formats
  # Supports: https://youtu.be/VIDEO_ID, https://youtube.com/watch?v=VIDEO_ID, https://www.youtube.com/watch?v=VIDEO_ID
  def youtube_video_id
    return nil if video_url.blank?

    # Try youtu.be format first
    return ::Regexp.last_match(1) if video_url.match(%r{youtu\.be/([^?&]+)})

    # Try youtube.com/watch?v= format
    return ::Regexp.last_match(1) if video_url.match(/[?&]v=([^&]+)/)

    nil
  end

  # Generate YouTube thumbnail URL (maxresdefault for high quality)
  def youtube_thumbnail_url
    return nil unless youtube_video_id

    "https://img.youtube.com/vi/#{youtube_video_id}/maxresdefault.jpg"
  end

  # Generate YouTube embed URL
  def youtube_embed_url
    return nil unless youtube_video_id

    "https://www.youtube.com/embed/#{youtube_video_id}"
  end
end
