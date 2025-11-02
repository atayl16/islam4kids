# Allow admin CRUD operations on Stories.
module Admin
  class StoriesController < Admin::BaseController
    def index
      @stories = Story.all
    end

    def show
      @story = Story.find(params[:id])
    end

    def new
      @story = Story.new
    end

    def edit
      @story = Story.find(params[:id])
    end

    def create
      @story = Story.new(story_params)
      if @story.save
        redirect_to admin_story_path(@story), notice: 'Story was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      @story = Story.find(params[:id])
      if @story.update(story_params)
        redirect_to admin_story_path(@story), notice: 'Story was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @story = Story.find(params[:id])
      @story.destroy
      redirect_to admin_stories_path
    end

    private

    def story_params
      params.expect(story: %i[title summary content status header_image])
    end
  end
end
