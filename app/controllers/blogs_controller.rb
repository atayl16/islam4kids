# All users can view blogs but not complete CRUD operations
class BlogsController < ApplicationController
  def index
    @blogs = Blog.published.order(created_at: :desc)
  end

  def show
    @blog = Blog.published.find(params[:id])
  end
end
