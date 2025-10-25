# All users can view blogs but not complete CRUD operations
module Public
  class BlogsController < ApplicationController
    def index
      @blogs = Blog.published
    end

    def show
      @blog = Blog.published.find(params[:id])
    end
  end
end
