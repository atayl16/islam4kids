# Allow admin CRUD operations on Blogs.
module Admin
  class BlogsController < Admin::BaseController
    def index
      @blogs = Blog.all
    end

    def show
      @blog = Blog.find(params[:id])
    end

    def new
      @blog = Blog.new
    end

    def edit
      @blog = Blog.find(params[:id])
    end

    def create
      @blog = Blog.new(blog_params)
      if @blog.save
        redirect_to admin_blog_path(@blog)
      else
        render :new
      end
    end

    def update
      @blog = Blog.find(params[:id])
      if @blog.update(blog_params)
        redirect_to admin_blog_path(@blog)
      else
        render :edit
      end
    end

    def destroy
      @blog = Blog.find(params[:id])
      @blog.destroy
      redirect_to admin_blogs_path
    end

    private

    def blog_params
      params.expect(blog: %i[title content status])
    end
  end
end
