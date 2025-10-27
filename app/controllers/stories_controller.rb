# All users can view stories but not complete CRUD operations
class StoriesController < ApplicationController
  def index
    @stories = Story.published.order(created_at: :desc)
  end

  def show
    @story = Story.published.find(params[:id])
  end
end
