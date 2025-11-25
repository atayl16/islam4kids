# Public-facing Videos controller for viewing published videos
class VideosController < ApplicationController
  def index
    @featured_video = Rails.cache.fetch('videos/featured-video', expires_in: 12.hours) do
      Video.published.featured.ordered.first
    end

    @videos = Rails.cache.fetch('videos/published-collection', expires_in: 12.hours) do
      # Get all published videos except the featured one (if it exists)
      scope = Video.published.ordered
      scope = scope.where.not(id: @featured_video.id) if @featured_video
      scope.to_a
    end
  end
end
