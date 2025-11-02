class StoriesController < ApplicationController
  def index
    @stories = Rails.cache.fetch('stories/published-collection', expires_in: 12.hours) do
      Story.published.order(created_at: :desc)
    end
  end

  def show
    @story = Rails.cache.fetch("stories/#{params[:id]}", expires_in: 12.hours) do
      Story.published.find(params[:id])
    end
  end
end
