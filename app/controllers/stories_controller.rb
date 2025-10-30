# All users can view stories but not complete CRUD operations
class StoriesController < ApplicationController
  def index
    @stories = Rails.cache.fetch('stories/published-collection', expires_in: 12.hours) do
      Story.published.order(created_at: :desc).to_a
    end
  end

  def show
    @story = Rails.cache.fetch("stories/#{params[:id]}", expires_in: 12.hours) do
      Story.published.find(params[:id])
    end
  end
end
