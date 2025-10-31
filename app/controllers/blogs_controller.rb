class BlogsController < ApplicationController
  def index
    @blogs = Rails.cache.fetch('blogs/published-collection', expires_in: 12.hours) do
      Blog.published.order(created_at: :desc).to_a
    end
  end

  def show
    @blog = Rails.cache.fetch("blogs/#{params[:id]}", expires_in: 12.hours) do
      Blog.published.find(params[:id])
    end
  end
end
